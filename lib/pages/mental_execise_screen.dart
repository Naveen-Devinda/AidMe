import 'package:aidme/constants/colors.dart';
import 'package:aidme/pages/execise_details.dart';
import 'package:aidme/services/recent_activity_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class MentalExeciseScreen extends StatefulWidget {
  final String illnessTitle;

  const MentalExeciseScreen({super.key, required this.illnessTitle});

  @override
  State<MentalExeciseScreen> createState() => _MentalExeciseScreenState();
}

class _MentalExeciseScreenState extends State<MentalExeciseScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  List<ExeciseDetails> get _execises {
    return mentalIllnessExecises[widget.illnessTitle] ??
        mentalIllnessExecises.values.first;
  }

  bool get _isFirstPage => _selectedIndex == 0;
  bool get _isLastPage => _selectedIndex == _execises.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _movePage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextOrDone() {
    if (_isLastPage) {
      RecentActivityService.add('Mental - ${widget.illnessTitle}');
      Navigator.pop(context);
      return;
    }

    _movePage(_selectedIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3FBBBB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Text(
              widget.illnessTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(34),
                    topRight: Radius.circular(34),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _execises.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return _ExecisePage(execise: _execises[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(34, 8, 34, 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SmallButton(
                            title: 'Previous',
                            isDisabled: _isFirstPage,
                            onTap: () {
                              if (!_isFirstPage) {
                                _movePage(_selectedIndex - 1);
                              }
                            },
                          ),
                          Row(
                            children: List.generate(
                              _execises.length,
                              (index) => Container(
                                width: _selectedIndex == index ? 18 : 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedIndex == index
                                      ? const Color(0xff3FBBBB)
                                      : const Color(0xffD8EEEE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          _SmallButton(
                            title: _isLastPage ? 'Done' : 'Next',
                            onTap: _nextOrDone,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExecisePage extends StatelessWidget {
  final ExeciseDetails execise;

  const _ExecisePage({required this.execise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        children: [
          const SizedBox(height: 44),
          Text(
            execise.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff3FBBBB),
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 28),
          _ExeciseMedia(execise: execise),
          const SizedBox(height: 24),
          Text(
            execise.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kBlackColor.withValues(alpha: 0.72),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffE8F8F8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              execise.mediaType.toUpperCase(),
              style: const TextStyle(
                color: Color(0xff3FBBBB),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExeciseMedia extends StatefulWidget {
  final ExeciseDetails execise;

  const _ExeciseMedia({required this.execise});

  @override
  State<_ExeciseMedia> createState() => _ExeciseMediaState();
}

class _ExeciseMediaState extends State<_ExeciseMedia> {
  VideoPlayerController? _videoController;
  bool _hasVideoError = false;

  bool get _isVideo => widget.execise.mediaType == 'video';

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void didUpdateWidget(covariant _ExeciseMedia oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.execise.mediaUrl != widget.execise.mediaUrl ||
        oldWidget.execise.mediaType != widget.execise.mediaType) {
      _videoController?.dispose();
      _videoController = null;
      _hasVideoError = false;
      _loadVideo();
    }
  }

  Future<void> _loadVideo() async {
    if (!_isVideo) {
      return;
    }

    try {
      final controller = VideoPlayerController.asset(widget.execise.mediaUrl);
      _videoController = controller;
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
    } catch (_) {
      _hasVideoError = true;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  bool get _isYoutube => widget.execise.mediaType == 'youtube';

  @override
  Widget build(BuildContext context) {
    if (_isYoutube) {
      return GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.execise.mediaUrl);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        child: Container(
          width: 230,
          height: 190,
          decoration: BoxDecoration(
            color: const Color(0xff3FBBBB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_fill, color: Color(0xff3FBBBB), size: 56),
              SizedBox(height: 8),
              Text(
                'Tap to watch',
                style: TextStyle(
                  color: Color(0xff3FBBBB),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isVideo) {
      final controller = _videoController;

      return SizedBox(
        width: 230,
        height: 190,
        child: _hasVideoError
            ? const Center(
                child: Text(
                  'Video not found',
                  style: TextStyle(
                    color: Color(0xff3FBBBB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : controller == null || !controller.value.isInitialized
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xff3FBBBB)),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    },
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: kWhiteColor.withValues(alpha: 0.88),
                      size: 58,
                    ),
                  ),
                ],
              ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.16,
          child: Image.asset(
            widget.execise.mediaUrl,
            width: 210,
            height: 190,
            fit: BoxFit.contain,
          ),
        ),
        Icon(
          _mediaIcon(widget.execise.mediaType),
          size: 88,
          color: const Color(0xff039A9A),
        ),
      ],
    );
  }

  IconData _mediaIcon(String mediaType) {
    if (mediaType == 'youtube') {
      return Icons.play_circle_fill;
    }
    if (mediaType == 'music') {
      return Icons.music_note;
    }
    if (mediaType == 'gif') {
      return Icons.auto_awesome_motion;
    }
    return Icons.image;
  }
}

class _SmallButton extends StatelessWidget {
  final String title;
  final bool isDisabled;
  final VoidCallback onTap;

  const _SmallButton({
    required this.title,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      height: 34,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff3FBBBB),
          disabledBackgroundColor: const Color(0xffCFEAEA),
          foregroundColor: kWhiteColor,
          disabledForegroundColor: kWhiteColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

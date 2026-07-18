import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenMediaViewer extends StatefulWidget {
  final String url;
  final bool isVideo;
  final Duration? startPosition;
  const FullScreenMediaViewer({
    super.key,
    required this.url,
    required this.isVideo,
    this.startPosition,
  });

  @override
  State<FullScreenMediaViewer> createState() => _FullScreenMediaViewerState();
}

class _FullScreenMediaViewerState extends State<FullScreenMediaViewer> {
  VideoPlayerController? _controller;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _controller = VideoPlayerController.asset(widget.url)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            if (widget.startPosition != null && widget.startPosition!.inSeconds > 0) {
              _controller!.seekTo(widget.startPosition!);
            }
            _controller!.play();
          }
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: widget.isVideo
            ? _controller != null && _controller!.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      setState(() => _showControls = !_showControls);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                        if (_showControls)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                iconSize: 64,
                                icon: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.play();
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: VideoProgressIndicator(
                                  _controller!,
                                  allowScrubbing: true,
                                  colors: const VideoProgressColors(
                                    playedColor: Color(0xff3FBBBB),
                                    bufferedColor: Colors.white30,
                                    backgroundColor: Colors.white12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  )
                : const CircularProgressIndicator(color: Colors.white)
            : InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.asset(widget.url, fit: BoxFit.contain),
              ),
      ),
    );
  }
}

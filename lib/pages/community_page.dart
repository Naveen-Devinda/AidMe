import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class CommunityPost {
  final String author;
  final String content;
  final String category;
  final DateTime timestamp;
  int likes;
  bool isLiked;
  final List<String> comments;

  CommunityPost({
    required this.author,
    required this.content,
    required this.category,
    required this.timestamp,
    this.likes = 0,
    this.isLiked = false,
    required this.comments,
  });
}

class _CommunityPageState extends State<CommunityPage> {
  final List<CommunityPost> _posts = [];
  String _currentUsername = "Guest User";
  final TextEditingController _postController = TextEditingController();
  String _selectedCategory = "Self Care";
  final List<String> _categories = ["Self Care", "Anxiety Tips", "Physical Fitness", "First Aid Tips", "General"];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadMockPosts();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUsername = prefs.getString("username") ?? "Guest User";
    });
  }

  void _loadMockPosts() {
    _posts.addAll([
      CommunityPost(
        author: "Sarah Jenkins",
        content: "Trying out the 4-7-8 breathing technique today for my work anxiety. It actually helped slow down my heart rate! Highly recommend it.",
        category: "Anxiety Tips",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 12,
        isLiked: false,
        comments: ["Agreed, it works wonders!", "I do this before bed too!"],
      ),
      CommunityPost(
        author: "David Lee",
        content: "Quick tip for minor cuts: Always wash with clean water and mild soap first. Avoid alcohol or hydrogen peroxide directly on the wound as they can delay healing.",
        category: "First Aid Tips",
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 24,
        isLiked: true,
        comments: ["Wow, didn't know that about alcohol. Thanks!"],
      ),
      CommunityPost(
        author: "Elena Rostova",
        content: "Don't forget to stretch your neck and shoulders today if you've been working at a computer for hours. A 5-minute break makes a huge difference.",
        category: "Self Care",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likes: 18,
        isLiked: false,
        comments: ["Just stood up to stretch, thank you!", "So needed this today."],
      ),
    ]);
  }

  void _createNewPost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffDBF8F2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Create Community Post",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3FBBBB),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Category selector
                    const Text(
                      "Category",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          items: _categories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setModalState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Post Content",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _postController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Share your wellness tips, queries, or stories...",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_postController.text.trim().isEmpty) return;

                          setState(() {
                            _posts.insert(
                              0,
                              CommunityPost(
                                author: _currentUsername,
                                content: _postController.text.trim(),
                                category: _selectedCategory,
                                timestamp: DateTime.now(),
                                comments: [],
                              ),
                            );
                          });

                          _postController.clear();
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Post shared with community!"),
                              backgroundColor: Color(0xff3FBBBB),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3FBBBB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Share Post",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showComments(CommunityPost post) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setCommentState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Comments (${post.comments.length})",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    if (post.comments.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text("No comments yet. Be the first to comment!"),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: post.comments.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xff3FBBBB).withValues(alpha: 0.2),
                                  child: const Icon(Icons.person, size: 16, color: Color(0xff3FBBBB)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBF8F2).withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(post.comments[index]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: "Write a comment...",
                              fillColor: const Color(0xffDBF8F2).withValues(alpha: 0.3),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send, color: Color(0xff3FBBBB)),
                          onPressed: () {
                            if (commentController.text.trim().isEmpty) return;
                            setState(() {
                              post.comments.add(commentController.text.trim());
                            });
                            setCommentState(() {}); // update modal sheet state
                            commentController.clear();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffDBF8F2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff98A9AA)),
        title: const Text(
          "Community Forum",
          style: TextStyle(
            color: Color(0xff98A9AA),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xff3FBBBB),
                            child: Text(
                              post.author[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.author,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Just now",
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xffDBF8F2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          post.category,
                          style: const TextStyle(
                            color: Color(0xff3FBBBB),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    post.content,
                    style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200, height: 1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              post.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: post.isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                post.isLiked = !post.isLiked;
                                if (post.isLiked) {
                                  post.likes++;
                                } else {
                                  post.likes--;
                                }
                              });
                            },
                          ),
                          Text(
                            "${post.likes} Likes",
                            style: const TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.comment_outlined, color: Colors.grey, size: 20),
                        label: Text(
                          "${post.comments.length} Comments",
                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        onPressed: () => _showComments(post),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewPost,
        backgroundColor: const Color(0xff3FBBBB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyNotesPage extends StatefulWidget {
  const DailyNotesPage({super.key});

  @override
  State<DailyNotesPage> createState() => _DailyNotesPageState();
}

class JournalNote {
  final String id;
  final String title;
  final String content;
  final String mood;
  final String emoji;
  final DateTime date;

  JournalNote({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.emoji,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'emoji': emoji,
      'date': date.toIso8601String(),
    };
  }

  factory JournalNote.fromMap(Map<String, dynamic> map) {
    return JournalNote(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      mood: map['mood'] ?? 'Calm',
      emoji: map['emoji'] ?? '😌',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class _DailyNotesPageState extends State<DailyNotesPage> {
  List<JournalNote> _notes = [];
  bool _isLoading = true;

  // New Note fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedMood = "Calm";
  String _selectedEmoji = "😌";

  final List<Map<String, String>> _moods = [
    {"mood": "Happy", "emoji": "😊"},
    {"mood": "Calm", "emoji": "😌"},
    {"mood": "Stressed", "emoji": "😰"},
    {"mood": "Sad", "emoji": "😢"},
    {"mood": "Tired", "emoji": "😴"},
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final notesString = prefs.getString('user_daily_notes');
      if (notesString != null) {
        final List<dynamic> decoded = json.decode(notesString);
        setState(() {
          _notes = decoded.map((item) => JournalNote.fromMap(item)).toList();
          // Sort notes by date descending (newest first)
          _notes.sort((a, b) => b.date.compareTo(a.date));
        });
      }
    } catch (e) {
      debugPrint("Error loading notes: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesListMap = _notes.map((note) => note.toMap()).toList();
      final notesString = json.encode(notesListMap);
      await prefs.setString('user_daily_notes', notesString);
    } catch (e) {
      debugPrint("Error saving notes: $e");
    }
  }

  void _addNote() {
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
                          "Write Daily Note",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff1C3D3D),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _titleController.clear();
                            _contentController.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "How are you feeling?",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    // Mood row selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _moods.map((m) {
                        final isSelected = _selectedMood == m["mood"];
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedMood = m["mood"]!;
                              _selectedEmoji = m["emoji"]!;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xff3FBBBB) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xff3FBBBB) : Colors.grey.shade300,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  m["emoji"]!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  m["mood"]!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Note Title",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: "Title of your entry...",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "What's on your mind?",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _contentController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: "Write down your daily logs, thoughts, or feelings...",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontStyle: FontStyle.italic),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill in both title and content."),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          final newNote = JournalNote(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: _titleController.text.trim(),
                            content: _contentController.text.trim(),
                            mood: _selectedMood,
                            emoji: _selectedEmoji,
                            date: DateTime.now(),
                          );

                          setState(() {
                            _notes.insert(0, newNote);
                          });

                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          await _saveNotes();

                          _titleController.clear();
                          _contentController.clear();
                          navigator.pop();
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text("Daily note saved!"),
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
                          "Save Note",
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

  void _deleteNote(JournalNote note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this daily note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              setState(() {
                _notes.removeWhere((n) => n.id == note.id);
              });
              await _saveNotes();
              navigator.pop();
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text("Note deleted successfully."),
                  backgroundColor: Color(0xffBB3F3F),
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Color(0xffBB3F3F))),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${dt.day} ${months[dt.month - 1]}, ${dt.year}";
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case "Happy":
        return const Color(0xffFFD700);
      case "Calm":
        return const Color(0xff3FBBBB);
      case "Stressed":
        return const Color(0xffFF8A65);
      case "Sad":
        return const Color(0xff64B5F6);
      case "Tired":
        return const Color(0xff9575CD);
      default:
        return const Color(0xff3FBBBB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F9F9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xffF4F9F9),
            elevation: 0,
            pinned: true,
            iconTheme: const IconThemeData(color: Color(0xff1C3D3D)),
            expandedHeight: 120.0,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                "My Journal",
                style: TextStyle(
                  color: Color(0xff1C3D3D),
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xff3FBBBB))),
            )
          else if (_notes.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_note, size: 100, color: Colors.grey.shade300),
                    const SizedBox(height: 20),
                    const Text(
                      "No journal entries yet.",
                      style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tap the + button to capture your day!",
                      style: TextStyle(color: Colors.black38, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final note = _notes[index];
                    final moodColor = _getMoodColor(note.mood);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: moodColor.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                        border: Border.all(color: moodColor.withValues(alpha: 0.3), width: 1.5),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: moodColor.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(note.emoji, style: const TextStyle(fontSize: 24)),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            note.title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff1C3D3D)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(note.date),
                                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.black26),
                                      onPressed: () => _deleteNote(note),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  note.content,
                                  style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.5),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: moodColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Mood: ${note.mood}",
                                    style: TextStyle(
                                      color: moodColor.withValues(alpha: 0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Decorative side line
                          Positioned(
                            left: 0,
                            top: 24,
                            bottom: 24,
                            child: Container(
                              width: 4,
                              decoration: BoxDecoration(
                                color: moodColor,
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: _notes.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        backgroundColor: const Color(0xff1C3D3D),
        elevation: 4,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text("New Entry", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:aidme/data/quiz_data.dart';

class FirstAidQuiz {
  final String questionEn;
  final List<String> optionsEn;
  final int answerIndex;
  final String explanationEn;

  const FirstAidQuiz({
    required this.questionEn,
    required this.optionsEn,
    required this.answerIndex,
    required this.explanationEn,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? _selectedSetIndex;
  List<FirstAidQuiz> _questions = [];

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;

  void _submitAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentIndex].answerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _answered = false;
    });
  }

  void _restartQuiz() {
    setState(() {
      _selectedSetIndex = null;
      _questions = [];
      _currentIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _answered = false;
    });
  }

  void _startQuizSet(int index) {
    setState(() {
      _selectedSetIndex = index;
      _questions = quizSets[index];
      _currentIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizFinished = _currentIndex >= _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xffDBF8F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffDBF8F2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff98A9AA)),
        title: const Text(
          "First Aid Quiz",
          style: TextStyle(
            color: Color(0xff98A9AA),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _selectedSetIndex == null
              ? _buildSetSelectionView()
              : (quizFinished ? _buildResultsView() : _buildQuizView()),
        ),
      ),
    );
  }

  Widget _buildSetSelectionView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select a Quiz Category",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff1C3D3D),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Each category has 10 questions. Test your knowledge!",
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: quizSets.length,
            itemBuilder: (context, index) {
              final categoryName = index < quizCategoryNames.length
                  ? quizCategoryNames[index]
                  : "Quiz Set ${index + 1}";
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: const Color(
                      0xff3FBBBB,
                    ).withValues(alpha: 0.15),
                    radius: 26,
                    child: const Icon(Icons.school, color: Color(0xff3FBBBB)),
                  ),
                  title: Text(
                    categoryName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "${quizSets[index].length} Questions",
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  trailing: const Icon(
                    Icons.play_circle_fill,
                    color: Color(0xff3FBBBB),
                    size: 36,
                  ),
                  onTap: () => _startQuizSet(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuizView() {
    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xffD8EEEE),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xff3FBBBB),
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              "${_currentIndex + 1}/${_questions.length}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Question Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                q.questionEn,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Options List
        Expanded(
          child: ListView.builder(
            itemCount: q.optionsEn.length,
            itemBuilder: (context, index) {
              Color optionColor = Colors.white;
              Color borderCol = Colors.grey.shade300;
              Widget? suffixIcon;

              if (_answered) {
                if (index == q.answerIndex) {
                  optionColor = const Color(0xffE2F9F5);
                  borderCol = const Color(0xff3FBBBB);
                  suffixIcon = const Icon(
                    Icons.check_circle,
                    color: Color(0xff3FBBBB),
                  );
                } else if (_selectedAnswer == index) {
                  optionColor = const Color(0xffFCEAEA);
                  borderCol = const Color(0xffBB3F3F);
                  suffixIcon = const Icon(
                    Icons.cancel,
                    color: Color(0xffBB3F3F),
                  );
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _submitAnswer(index),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: optionColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderCol, width: 2),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: _answered && index == q.answerIndex
                              ? const Color(0xff3FBBBB)
                              : Colors.grey[200],
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _answered && index == q.answerIndex
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.optionsEn[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ?suffixIcon,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Explanation at bottom & Next Button
        if (_answered) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffD8EEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _selectedAnswer == q.answerIndex
                          ? Icons.check_circle
                          : Icons.info_outline,
                      color: _selectedAnswer == q.answerIndex
                          ? const Color(0xff2E7D32)
                          : const Color(0xff3FBBBB),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedAnswer == q.answerIndex
                          ? "Correct!"
                          : "Incorrect",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _selectedAnswer == q.answerIndex
                            ? const Color(0xff2E7D32)
                            : const Color(0xffBB3F3F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  q.explanationEn,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3FBBBB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _currentIndex + 1 >= _questions.length
                    ? "See Results"
                    : "Next Question",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultsView() {
    double percent = (_score / _questions.length) * 100;
    String categoryName =
        _selectedSetIndex != null &&
            _selectedSetIndex! < quizCategoryNames.length
        ? quizCategoryNames[_selectedSetIndex!]
        : "Quiz Set ${(_selectedSetIndex ?? 0) + 1}";

    // Determine level
    String level;
    Color levelColor;
    IconData levelIcon;
    if (percent >= 80) {
      level = "Expert";
      levelColor = Colors.green;
      levelIcon = Icons.emoji_events;
    } else if (percent >= 60) {
      level = "Intermediate";
      levelColor = Colors.orange;
      levelIcon = Icons.thumb_up;
    } else if (percent >= 40) {
      level = "Beginner";
      levelColor = Colors.blue;
      levelIcon = Icons.school;
    } else {
      level = "Needs Practice";
      levelColor = Colors.red;
      levelIcon = Icons.menu_book;
    }

    String feedback;
    if (percent >= 80) {
      feedback = "Excellent! You are a first aid expert!";
    } else if (percent >= 60) {
      feedback = "Good job! You have solid knowledge.";
    } else if (percent >= 40) {
      feedback = "Not bad! Review the guides to improve.";
    } else {
      feedback = "Keep learning! Check the first aid guides.";
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(levelIcon, size: 80, color: levelColor),
            const SizedBox(height: 20),
            const Text(
              "Quiz Complete!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              categoryName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            // Score Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: levelColor.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "$_score / ${_questions.length}",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff1C3D3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${percent.toInt()}%",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: levelColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: levelColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: levelColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      "Level: $level",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: levelColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    feedback,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xff3FBBBB),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Go Home",
                        style: TextStyle(
                          color: Color(0xff3FBBBB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _restartQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3FBBBB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Try Again",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

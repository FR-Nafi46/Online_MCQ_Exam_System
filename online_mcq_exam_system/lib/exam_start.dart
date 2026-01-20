import 'package:flutter/material.dart';
import 'dart:async';
import 'question.dart';
import 'supabase_service.dart';

class ExamStartPage extends StatefulWidget {
  final String examType;
  final int questionNumber;
  final int totalQuestions;
  final int timeLimit;

  const ExamStartPage({
    super.key,
    required this.examType,
    required this.questionNumber,
    required this.totalQuestions,
    required this.timeLimit,
  });

  @override
  State<ExamStartPage> createState() => _ExamStartPageState();
}

class _ExamStartPageState extends State<ExamStartPage> {
  Timer? _timer;
  int _secondsRemaining = 0;
  int _currentQuestionIndex = 0;
  List<Question> _questions = [];
  List<int?> _userAnswers = [];
  bool _examStarted = false;
  bool _examFinished = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? _examResult;
  final SupabaseService _server = SupabaseService();

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.timeLimit * 60;
    _currentQuestionIndex = widget.questionNumber - 1;
    _userAnswers = List.filled(widget.totalQuestions, null);
    _loadQuestions();
  }

  void _loadQuestions() {
    List<Question> bank;
    switch (widget.examType) {
      case 'C':
        bank = QuestionBank.getCQuestions();
        break;
      case 'C++':
        bank = QuestionBank.getCppQuestions();
        break;
      case 'Python':
        bank = QuestionBank.getPythonQuestions();
        break;
      case 'Dart':
        bank = QuestionBank.getDartQuestions();
        break;
      case 'General Knowledge':
        bank = QuestionBank.getGKQuestions();
        break;
      default:
        bank = [];
    }

    _questions = List.from(bank);
    if (_questions.length < widget.totalQuestions) {
      int needed = widget.totalQuestions - _questions.length;
      for (int i = 0; i < needed; i++) {
        _questions.add(Question(
          id: 999 + i,
          question: "Sample Question ${i + 1}",
          options: ["Option A", "Option B", "Option C", "Option D"],
          correctAnswerIndex: 0,
          explanation: "This is a placeholder question.",
        ));
      }
    }
  }

  void _startExam() {
    setState(() => _examStarted = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _finishExam();
      }
    });
  }

  Future<void> _finishExam() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    _timer?.cancel();

    int correctAnswers = 0;
    List<Map<String, dynamic>> questionResults = [];

    for (int i = 0; i < widget.totalQuestions; i++) {
      bool isCorrect = _userAnswers[i] == _questions[i].correctAnswerIndex;
      if (isCorrect) correctAnswers++;

      questionResults.add({
        'question': _questions[i].question,
        'userAnswer': _userAnswers[i] != null
            ? _questions[i].options[_userAnswers[i]!]
            : 'Not answered',
        'correctAnswer':
        _questions[i].options[_questions[i].correctAnswerIndex],
        'isCorrect': isCorrect,
        'explanation': _questions[i].explanation,
      });
    }

    String? studentId = _server.getCurrentStudentId();
    bool isFirstAttempt = false;
    int pointsAdded = 0;
    int bonusPoints = 0;

    if (studentId != null) {
      final history = _server.getStudentExamHistoryLocal(widget.examType);
      isFirstAttempt = !(history['hasTaken'] ?? false);

      final updateResult = await _server.updateStudentScore(
        studentId: studentId,
        examType: widget.examType,
        correctAnswers: correctAnswers,
        totalQuestions: widget.totalQuestions,
      );

      pointsAdded = updateResult['pointsAdded'] ?? 0;
      bonusPoints = updateResult['bonusPoints'] ?? 0;
    }

    setState(() {
      _examResult = {
        'correctAnswers': correctAnswers,
        'totalQuestions': widget.totalQuestions,
        'isFirstAttempt': isFirstAttempt,
        'bonusPoints': bonusPoints,
        'pointsAdded': pointsAdded,
        'results': questionResults,
      };
      _examFinished = true;
      _isSubmitting = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.examType} Exam',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        leading: !_examStarted || _examFinished
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        )
            : null,
        actions: [
          if (_examStarted && !_examFinished)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _secondsRemaining < 60
                        ? Colors.red
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        "${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
      body: _isSubmitting
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _examFinished
          ? _buildResultsScreen()
          : _examStarted
          ? _buildExamScreen()
          : _buildStartScreen(),
    );
  }

  Widget _buildStartScreen() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Icon(_getExamIcon(), size: 80, color: Colors.teal),
                  const SizedBox(height: 20),
                  Text('${widget.examType} Exam',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal)),
                  const Divider(height: 30),
                  _buildInfoRow('Total Questions', '${widget.totalQuestions}'),
                  _buildInfoRow('Time Limit', '${widget.timeLimit} minutes'),
                  const SizedBox(height: 20),
                  const Text('Scoring System:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildRule('+5 points for first attempt'),
                  _buildRule('+1 point for each correct answer'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startExam,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Start Exam',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / widget.totalQuestions,
          backgroundColor: Colors.grey[300],
          color: Colors.teal,
          minHeight: 6,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question ${_currentQuestionIndex + 1} of ${widget.totalQuestions}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Text(
                  '${_userAnswers.where((a) => a != null).length}/${widget.totalQuestions} Answered',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade200, width: 2),
                  ),
                  child: Text(
                    currentQuestion.question,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(currentQuestion.options.length, (index) {
                  final isSelected = _userAnswers[_currentQuestionIndex] == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      color: isSelected ? Colors.teal[50] : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: isSelected ? Colors.teal : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RadioListTile<int>(
                        title: Text(
                          currentQuestion.options[index],
                          style: TextStyle(
                            fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        value: index,
                        groupValue: _userAnswers[_currentQuestionIndex],
                        activeColor: Colors.teal,
                        onChanged: (val) => setState(
                                () => _userAnswers[_currentQuestionIndex] = val),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentQuestionIndex > 0)
                ElevatedButton.icon(
                  onPressed: () =>
                      setState(() => _currentQuestionIndex--),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Previous",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                )
              else
                const SizedBox.shrink(),
              if (_currentQuestionIndex < widget.totalQuestions - 1)
                ElevatedButton.icon(
                  onPressed: () =>
                      setState(() => _currentQuestionIndex++),
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label:
                  const Text("Next", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                )
              else
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: _finishExam,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("Finish Exam",
                      style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildResultsScreen() {
    final res = _examResult!;
    final percentage =
    (res['correctAnswers'] / res['totalQuestions'] * 100).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: percentage >= 70
                    ? [Colors.green.shade400, Colors.green.shade600]
                    : percentage >= 50
                    ? [Colors.orange.shade400, Colors.orange.shade600]
                    : [Colors.red.shade400, Colors.red.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  percentage >= 70
                      ? Icons.emoji_events
                      : percentage >= 50
                      ? Icons.thumb_up
                      : Icons.refresh,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Exam Completed!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "${res['correctAnswers']} / ${res['totalQuestions']}",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$percentage% Correct',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Points Earned: ${res['pointsAdded']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (res['isFirstAttempt'])
                        Text(
                          '(+${res['bonusPoints']} First Attempt Bonus)',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("Question Review",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...List.generate(res['results'].length, (index) {
            final q = res['results'][index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: q['isCorrect']
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    q['isCorrect'] ? Icons.check : Icons.close,
                    color:
                    q['isCorrect'] ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
                title: Text(
                  "Question ${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(q['isCorrect'] ? 'Correct' : 'Incorrect',
                    style: TextStyle(
                        color: q['isCorrect'] ? Colors.green : Colors.red)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(q['question'],
                            style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("Your Answer: ${q['userAnswer']}",
                                    style: const TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                    "Correct Answer: ${q['correctAnswer']}",
                                    style:
                                    const TextStyle(color: Colors.green)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline,
                                  color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("${q['explanation']}",
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home, color: Colors.white),
              label:
              const Text("Back to Home", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getExamIcon() {
    switch (widget.examType) {
      case 'C':
        return Icons.code;
      case 'C++':
        return Icons.code_off;
      case 'Python':
        return Icons.settings_ethernet;
      case 'Dart':
        return Icons.phone_iphone;
      case 'General Knowledge':
        return Icons.lightbulb;
      default:
        return Icons.quiz;
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRule(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
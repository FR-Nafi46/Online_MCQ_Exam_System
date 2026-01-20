import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'student_profile.dart';
import 'exam.dart';
import 'leaderboard.dart';
import 'review.dart';
import 'supabase_service.dart'; // Import your service

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> with SingleTickerProviderStateMixin {
  final SupabaseService _service = SupabaseService(); // Use your service
  final supabase = Supabase.instance.client;

  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;

  String _studentName = "Loading...";
  int _score = 0;
  int _rank = 0;
  String? _studentId;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _scoreAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      // Get current student from your service
      final currentStudent = _service.getCurrentStudent();

      if (currentStudent == null) {
        setState(() {
          _studentName = "Not Logged In";
          _score = 0;
          _rank = 0;
          _loading = false;
        });
        return;
      }

      _studentId = currentStudent['id']; // Fixed: using correct variable name

      final name = currentStudent['name'] ?? 'Student';
      final score = currentStudent['score'] ?? 0;

      // Fetch all students sorted by score descending - FIXED: removed .execute()
      final allStudents = await supabase
          .from('students')
          .select('id, score')
          .order('score', ascending: false);

      int rank = 0;
      final List<dynamic> studentList = List<dynamic>.from(allStudents);
      for (int i = 0; i < studentList.length; i++) {
        if (studentList[i]['id'] == _studentId) { // Fixed: using correct variable name
          rank = i + 1;
          break;
        }
      }

      setState(() {
        _studentName = name;
        _score = score;
        _rank = rank;
        _scoreAnimation = Tween<double>(begin: 0, end: _score.toDouble()).animate(
          CurvedAnimation(
            parent: _scoreAnimationController,
            curve: Curves.easeOut,
          ),
        );
        _scoreAnimationController.forward();
        _loading = false;
      });

      print('✅ Home Page Loaded for: $_studentName');
      print('✅ Score: $_score');
      print('✅ Rank: $_rank');
    } catch (e) {
      print('⚠️ Failed to load student data: $e');
      setState(() {
        _studentName = "Error loading data";
        _score = 0;
        _rank = 0;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.teal),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are already on home page')),
            );
          },
        ),
        title: const Text('Student Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentProfilePage()),
              );
            },
            tooltip: 'View Profile',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.teal, Colors.blue.shade300],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.5),
                      blurRadius: 15.0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Profile Picture
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _studentName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Score and Rank
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Score
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('SCORE',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      )),
                                  const SizedBox(height: 10),
                                  AnimatedBuilder(
                                    animation: _scoreAnimation,
                                    builder: (context, child) {
                                      return Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: _getScoreColor(_score),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 15.0,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          _scoreAnimation.value.toInt().toString(),
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Rank
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('RANK',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      )),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5.0,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '#$_rank',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Middle Row - Exam and Leaderboard
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildDashboardButton(
                        icon: Icons.assignment_outlined,
                        label: 'Exam',
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ExamPage()),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildDashboardButton(
                        icon: Icons.leaderboard_outlined,
                        label: 'Leaderboard',
                        color: Colors.orange,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LeaderboardPage()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Row - Review
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: _buildDashboardButton(
                      icon: Icons.feedback_outlined,
                      label: 'Review',
                      color: Colors.purple,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReviewPage()),
                        );
                      },
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12.0,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6.0,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: onPressed,
            splashColor: color.withOpacity(0.2),
            highlightColor: color.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 42, color: color),
                  const SizedBox(height: 10),
                  Text(label,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }
}
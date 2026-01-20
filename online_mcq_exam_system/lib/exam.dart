import 'package:flutter/material.dart';
import 'c_exam_set.dart';
import 'cpp_exam_set.dart';
import 'py_exam_set.dart';
import 'dart_exam_set.dart';
import 'gk_exam_set.dart';

class ExamPage extends StatelessWidget {
  const ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Select Exam Category',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            // 1 no row
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildExamButton(
                        label: 'C',
                        color: Colors.blue,
                        icon: Icons.memory,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CExamSetPage()),
                          );
                        },
                      ),
                    ),
                  ),

                  // C++ Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildExamButton(
                        label: 'C++',
                        color: Colors.blue.shade700,
                        icon: Icons.electric_bolt, // Settings/Gear for C++ (system programming)
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CppExamSetPage()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Second row - Python and Dart
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  // Python Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildExamButton(
                        label: 'Python',
                        color: Colors.green,
                        icon: Icons.psychology, // Brain/Intelligence for Python (AI/ML)
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PyExamSetPage()),
                          );
                        },
                      ),
                    ),
                  ),

                  // Dart Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildExamButton(
                        label: 'Dart',
                        color: Colors.blue.shade300,
                        icon: Icons.phone_iphone, // Mobile for Dart/Flutter
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DartExamSetPage()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Third row - General Knowledge (centered)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  // Left spacer
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),

                  // General Knowledge Button
                  Expanded(
                    flex: 2,
                    child: _buildExamButton(
                      label: 'General\nKnowledge',
                      color: Colors.purple,
                      icon: Icons.lightbulb, // Lightbulb for knowledge
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GkExamSetPage()),
                        );
                      },
                    ),
                  ),

                  // Right spacer
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create exam category buttons
  Widget _buildExamButton({
    required String label,
    required Color color,
    required IconData icon,
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
                  // Container with icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 36,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
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
}
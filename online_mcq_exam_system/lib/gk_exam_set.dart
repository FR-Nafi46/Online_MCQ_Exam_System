import 'package:flutter/material.dart';
import 'exam_start.dart';
import 'question.dart';

class GkExamSetPage extends StatelessWidget {
  const GkExamSetPage({super.key});

  int get totalGkSets =>
      QuestionBank.getGKQuestions().isNotEmpty ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Knowledge Exam', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            // 🔹 Exam Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'General Knowledge',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.layers, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '$totalGkSets Set',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.timer, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '25 Minutes',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 GK Set (compact height)
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: Colors.purple.withOpacity(0.3)),
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    title: const Text(
                      'General Knowledge Set',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text('Click to start exam'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExamStartPage(
                            examType: 'General Knowledge',
                            questionNumber: 1,
                            totalQuestions: 10,
                            timeLimit: 25,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'exam_start.dart';
import 'question.dart';

class PyExamSetPage extends StatelessWidget {
  const PyExamSetPage({super.key});

  int get totalPythonSets => [
    QuestionBank.getPythonSet1(),
    QuestionBank.getPythonSet2(),
  ].where((set) => set.isNotEmpty).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Programming Exam', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
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
                    'Python Programming Fundamentals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.layers, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '$totalPythonSets Sets',
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

            // 🔹 Exam Set List
            Expanded(
              child: ListView.builder(
                itemCount: totalPythonSets,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        'Set ${index + 1}',
                        style: const TextStyle(
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
                            builder: (context) => ExamStartPage(
                              examType: 'Python',
                              questionNumber: index + 1, // 🔹 SET NUMBER
                              totalQuestions: 10,
                              timeLimit: 25,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

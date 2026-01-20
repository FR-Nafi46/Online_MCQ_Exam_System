import 'package:flutter/material.dart';
import 'supabase_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final SupabaseService _server = SupabaseService();
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      // Fetch students sorted by score from SupabaseService
      final students = await _server.getLeaderboard();

      // Assign ranks dynamically
      for (int i = 0; i < students.length; i++) {
        students[i]['rank'] = i + 1;
      }

      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading leaderboard: $e');
      setState(() {
        _students = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🏆 Student Leaderboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      )
          : _students.isEmpty
          ? _buildEmptyState()
          : _buildLeaderboardContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'No Students Registered Yet',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 10),
          Text(
            'Be the first to register!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardContent() {
    return Column(
      children: [
        // Top performers
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: _buildTopPerformers(),
        ),

        // All students
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _students.length,
            itemBuilder: (context, index) {
              final student = _students[index];
              return _buildStudentCard(student);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopPerformers() {
    final top3 = _students.take(3).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade600, Colors.purple.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'TOP PERFORMERS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (top3.length >= 2) _buildTopRankCard(top3[1], 2),
                if (top3.isNotEmpty) _buildTopRankCard(top3[0], 1),
                if (top3.length >= 3) _buildTopRankCard(top3[2], 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRankCard(Map<String, dynamic> student, int position) {
    final colors = [
      Colors.yellow.shade700,
      Colors.grey.shade400,
      Colors.orange.shade400,
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors[position - 1],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  position == 1
                      ? Icons.emoji_events
                      : position == 2
                      ? Icons.military_tech
                      : Icons.workspace_premium,
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(height: 2),
                Text(
                  '#${student['rank']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 80,
          child: Text(
            student['name'],
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${student['score']} pts',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final rank = student['rank'];
    final score = student['score'] ?? 0;
    final name = student['name'];
    final studentId = student['id'] ?? 'Unknown';

    Color rankColor;
    if (rank <= 3) {
      rankColor = Colors.deepPurple;
    } else if (rank <= 10) {
      rankColor = Colors.blue;
    } else if (rank <= 20) {
      rankColor = Colors.green;
    } else {
      rankColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: rankColor.withOpacity(0.2), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: rankColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: rankColor.withOpacity(0.3), width: 1.5),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          studentId,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: rankColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'pts',
                style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),
        onTap: () => _showStudentDetails(student),
      ),
    );
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          student['name'],
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Student ID', student['id'] ?? 'N/A'),
              _buildDetailRow('Rank', '#${student['rank']}'),
              _buildDetailRow('Score', '${student['score'] ?? 0} points'),
              _buildDetailRow('Role', student['role'] ?? 'Student'),
              if (student['mobile'] != null) _buildDetailRow('Mobile', student['mobile']),
              if (student['createdAt'] != null)
                _buildDetailRow(
                    'Joined', student['createdAt'].toString().split('T')[0]),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

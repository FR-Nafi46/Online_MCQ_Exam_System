import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  String? currentStudentId;
  Map<String, dynamic>? currentStudentData;

  // ============= STUDENT OPERATIONS =============

  Future<String> registerStudent({
    required String name,
    required String password,
    required String mobile,
    required String email,
  }) async {
    // Generate student ID in stu001 format
    final result = await client
        .from('students')
        .select('id')
        .order('id', ascending: false)
        .limit(1)
        .maybeSingle();

    int nextNum = 1;
    if (result != null && result['id'] != null) {
      final String lastId = result['id'];
      final numPart = lastId.replaceAll(RegExp(r'[^0-9]'), '');
      nextNum = (int.tryParse(numPart) ?? 0) + 1;
    }

    final studentId = 'stu${nextNum.toString().padLeft(3, '0')}';

    await client.from('students').insert({
      'id': studentId,
      'name': name,
      'password': password,
      'mobile': mobile,
      'email': email,
      'score': 0,
      'total_exams_taken': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    return studentId;
  }

  // Find user by name and mobile for password recovery
  Future<Map<String, dynamic>?> findUserByNameAndMobile(
      String name, String mobile) async {
    final result = await client
        .from('students')
        .select()
        .eq('name', name)
        .eq('mobile', mobile)
        .maybeSingle();

    if (result != null) {
      return Map<String, dynamic>.from(result);
    }
    return null;
  }

  // Reset password
  Future<bool> resetPassword(String studentId, String newPassword) async {
    try {
      await client
          .from('students')
          .update({'password': newPassword}).eq('id', studentId);

      return true;
    } catch (e) {
      print('Error resetting password: $e');
      return false;
    }
  }

  // Login student
  Future<Map<String, dynamic>?> loginStudent(String id, String password) async {
    final normalizedId = id.toLowerCase().trim();

    final result = await client
        .from('students')
        .select()
        .eq('id', normalizedId)
        .eq('password', password)
        .maybeSingle();

    if (result != null) {
      currentStudentId = result['id'];
      currentStudentData = Map<String, dynamic>.from(result);

      final examHistory = await getExamHistory(normalizedId);
      currentStudentData!['examHistory'] = examHistory;
      currentStudentData!['examsTaken'] = examHistory.keys.toList();

      return currentStudentData;
    }
    return null;
  }

  // Get exam history
  Future<Map<String, dynamic>> getExamHistory(String studentId) async {
    final result =
    await client.from('exam_history').select().eq('student_id', studentId);

    Map<String, dynamic> history = {};
    for (var exam in result) {
      history[exam['exam_type']] = {
        'attempts': exam['attempts'] ?? 0,
        'bestScore': exam['best_score'] ?? 0,
        'lastScore': exam['last_score'] ?? 0,
        'totalQuestions': exam['total_questions'] ?? 0,
        'lastAttempt': exam['last_attempt'],
        'hasTaken': true,
      };
    }
    return history;
  }

  // Get local exam history
  Map<String, dynamic> getStudentExamHistoryLocal(String examType) {
    final history = currentStudentData?['examHistory'] ?? {};
    if (history.containsKey(examType)) {
      return Map<String, dynamic>.from(history[examType]);
    }
    return {'hasTaken': false};
  }

  // Update student score with proper point calculation
  Future<Map<String, dynamic>> updateStudentScore({
    required String studentId,
    required String examType,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    try {
      // Check if this exam type has been taken before
      final existingHistory = await client
          .from('exam_history')
          .select()
          .eq('student_id', studentId)
          .eq('exam_type', examType)
          .maybeSingle();

      bool isFirstAttempt = existingHistory == null;

      // Calculate points: 5 points for first attempt + 1 point per correct answer
      int pointsForCorrectAnswers = correctAnswers;
      int bonusPoints = isFirstAttempt ? 5 : 0;
      int totalPointsToAdd = pointsForCorrectAnswers + bonusPoints;

      // Update or insert exam history
      if (!isFirstAttempt) {
        int newBestScore = correctAnswers;
        if (existingHistory['best_score'] != null &&
            existingHistory['best_score'] > correctAnswers) {
          newBestScore = existingHistory['best_score'];
        }

        await client.from('exam_history').update({
          'attempts': (existingHistory['attempts'] ?? 0) + 1,
          'last_score': correctAnswers,
          'best_score': newBestScore,
          'total_questions': totalQuestions,
          'last_attempt': DateTime.now().toIso8601String(),
        }).eq('student_id', studentId).eq('exam_type', examType);
      } else {
        await client.from('exam_history').insert({
          'student_id': studentId,
          'exam_type': examType,
          'attempts': 1,
          'best_score': correctAnswers,
          'last_score': correctAnswers,
          'total_questions': totalQuestions,
          'last_attempt': DateTime.now().toIso8601String(),
        });
      }

      // Get current student data
      final studentData =
      await client.from('students').select().eq('id', studentId).single();

      int currentScore = studentData['score'] ?? 0;
      int currentTotalExams = studentData['total_exams_taken'] ?? 0;

      // Update student score and exam count
      await client.from('students').update({
        'score': currentScore + totalPointsToAdd,
        'total_exams_taken': currentTotalExams + 1,
      }).eq('id', studentId);

      // Refresh current student data
      await refreshCurrentStudent();

      return {
        'success': true,
        'pointsAdded': totalPointsToAdd,
        'bonusPoints': bonusPoints,
        'isFirstAttempt': isFirstAttempt,
      };
    } catch (e) {
      print('Error updating student score: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Refresh current student data
  Future<void> refreshCurrentStudent() async {
    if (currentStudentId != null) {
      final result = await client
          .from('students')
          .select()
          .eq('id', currentStudentId!)
          .maybeSingle();

      if (result != null) {
        currentStudentData = Map<String, dynamic>.from(result);
        final examHistory = await getExamHistory(currentStudentId!);
        currentStudentData!['examHistory'] = examHistory;
        currentStudentData!['examsTaken'] = examHistory.keys.toList();
      }
    }
  }

  // Get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final result =
    await client.from('students').select().order('score', ascending: false);

    final list = List<Map<String, dynamic>>.from(result);
    for (int i = 0; i < list.length; i++) {
      list[i]['rank'] = i + 1;
    }
    return list;
  }

  // Update student profile
  Future<bool> updateStudentProfile({
    required String studentId,
    required String name,
    required String mobile,
    required String email,
    String? university,
  }) async {
    try {
      await client.from('students').update({
        'name': name,
        'mobile': mobile,
        'email': email,
        'university': university ?? '',
      }).eq('id', studentId);

      // Refresh current student data
      await refreshCurrentStudent();
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Verify password
  Future<bool> verifyPassword(String studentId, String password) async {
    try {
      final result = await client
          .from('students')
          .select()
          .eq('id', studentId)
          .eq('password', password)
          .maybeSingle();

      return result != null;
    } catch (e) {
      print('Error verifying password: $e');
      return false;
    }
  }

  // Get current student
  Map<String, dynamic>? getCurrentStudent() => currentStudentData;

  // Get current student ID
  String? getCurrentStudentId() => currentStudentId;

  // Clear current session
  void clearCurrentStudent() {
    currentStudentId = null;
    currentStudentData = null;
  }
}
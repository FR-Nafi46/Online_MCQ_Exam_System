import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final supabase = Supabase.instance.client;
  final SupabaseService _service = SupabaseService();

  final TextEditingController _reviewController = TextEditingController();
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;
  String? _currentStudentId;
  String? _currentStudentName;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndReviews();
  }

  Future<void> _loadCurrentUserAndReviews() async {
    try {
      final currentStudent = _service.getCurrentStudent();

      if (currentStudent == null) {
        setState(() {
          _currentStudentId = null;
          _currentStudentName = null;
        });
      } else {
        _currentStudentId = currentStudent['id'];
        _currentStudentName = currentStudent['name'];
      }

      final response = await supabase
          .from('reviews')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _reviews = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading reviews: $e');
      setState(() {
        _reviews = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _submitReview() async {
    final reviewText = _reviewController.text.trim();
    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something before submitting!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_currentStudentId == null || _currentStudentName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final now = DateTime.now().toIso8601String();

      final response = await supabase.from('reviews').insert({
        'student_id': _currentStudentId,
        'student_name': _currentStudentName,
        'review': reviewText,
        'created_at': now,
      }).select().single();

      setState(() {
        _reviews.insert(0, Map<String, dynamic>.from(response));
      });

      _reviewController.clear();
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit review!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteReview(String reviewId, String ownerId) async {
    if (_currentStudentId != ownerId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only delete your own reviews!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await supabase.from('reviews').delete().eq('id', reviewId);

      setState(() {
        _reviews.removeWhere((r) => r['id'] == reviewId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review deleted!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error deleting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete review!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Review',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildWriteReviewSection(),
          Expanded(
            child: _isLoading
                ? const Center(
                child: CircularProgressIndicator(color: Colors.purple))
                : _reviews.isEmpty
                ? _buildEmptyState()
                : _buildReviewsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWriteReviewSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.purple[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share Your Thoughts',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
          const SizedBox(height: 8),
          const Text(
            'Write your feedback, suggestions, or complaints',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reviewController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Type your review here...',
              filled: true,
              fillColor: Colors.white,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.purple, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Submit Review',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        final isMyReview = review['student_id'] == _currentStudentId;
        return _buildReviewCard(review, isMyReview);
      },
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, bool isMyReview) {
    String formattedTime = '';
    try {
      if (review['created_at'] != null) {
        final dateTime = DateTime.parse(review['created_at']).toLocal();
        formattedTime =
        '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      formattedTime = 'Unknown date';
    }

    final studentName = review['student_name']?.toString() ?? 'Unknown';
    final displayName = studentName.isNotEmpty ? studentName : 'Anonymous';
    final displayInitial =
    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isMyReview
                            ? Colors.purple.shade100
                            : Colors.grey.shade300,
                        child: Text(
                          displayInitial,
                          style: TextStyle(
                            color: isMyReview ? Colors.purple : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              review['student_id']?.toString() ?? 'N/A',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isMyReview)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteReview(review['id'].toString(),
                        review['student_id'].toString()),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review['review']?.toString() ?? '',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedTime,
                  style:
                  TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (isMyReview)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.shade100),
                    ),
                    child: const Text(
                      'Your Review',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.reviews_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          const Text(
            'No Reviews Yet',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          const Text(
            'Be the first to share your thoughts!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
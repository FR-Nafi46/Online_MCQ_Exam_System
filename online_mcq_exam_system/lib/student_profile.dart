import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'student_home_page.dart';
import 'account.dart';
import 'supabase_service.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final supabase = Supabase.instance.client;
  final SupabaseService _service = SupabaseService();

  bool _isEditing = false;
  bool _isLoading = false;
  bool _showPassword = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, dynamic>? _studentData;
  String? _studentId;

  @override
  void initState() {
    super.initState();
    _loadCurrentStudentData();
  }

  Future<void> _loadCurrentStudentData() async {
    setState(() => _isLoading = true);

    try {
      // Get student data from your service
      final student = _service.getCurrentStudent();
      if (student == null) {
        print('❌ No student found in service');
        setState(() => _isLoading = false);
        return;
      }

      _studentId = student['id']; // Get student ID from service
      _studentData = student;

      print('✅ Loaded student ID: $_studentId');
      print('✅ Student data: $_studentData');

      _nameController.text = _studentData?['name'] ?? '';
      _mobileController.text = _studentData?['mobile'] ?? '';
      _emailController.text = _studentData?['email'] ?? '';
      _universityController.text = _studentData?['university'] ?? '';

      setState(() => _isLoading = false);
    } catch (e) {
      print('❌ Error loading student data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_studentData == null || _studentId == null) {
      print('❌ Cannot save: student data or ID is null');
      return;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password to save changes'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      print('🔍 Verifying password for student ID: $_studentId');

      // Verify password by checking against the students table
      final passwordCheck = await supabase
          .from('students')
          .select()
          .eq('id', _studentId!)
          .eq('password', _passwordController.text.trim())
          .maybeSingle();

      if (passwordCheck == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect password'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      final updates = {
        'name': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'email': _emailController.text.trim(),
        'university': _universityController.text.trim(),
      };

      print('📝 Updating profile with: $updates');

      await supabase
          .from('students')
          .update(updates)
          .eq('id', _studentId!);

      // Refresh the student data in the service
      await _service.refreshCurrentStudent();

      // Reload local data
      await _loadCurrentStudentData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _passwordController.clear();
      _isEditing = false;
    } catch (e) {
      print('❌ Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signOut() async {
    // Clear the current student data from service
    _service.currentStudentId = null;
    _service.currentStudentData = null;

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AccountPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'Student Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _studentData == null
          ? const Center(child: Text('No student logged in'))
          : Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 360,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile Picture & Name
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.teal[100],
                          backgroundImage: _studentData!['profileImage'] != null
                              ? NetworkImage(_studentData!['profileImage'])
                              : null,
                          child: _studentData!['profileImage'] == null
                              ? const Icon(Icons.person, size: 50, color: Colors.teal)
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${_studentData?['name'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'ID: ${_studentId ?? 'No ID'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Name Field
                        _buildInfoField('Full Name', _nameController),
                        const SizedBox(height: 20),

                        // Mobile Field
                        _buildInfoField('Mobile', _mobileController, keyboardType: TextInputType.phone),
                        const SizedBox(height: 20),

                        // Email Field
                        _buildInfoField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 20),

                        // University Field
                        _buildInfoField('University', _universityController),
                        const SizedBox(height: 20),

                        // Password to save
                        if (_isEditing)
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            cursorColor: Colors.teal,
                            cursorWidth: 2.0,
                            cursorHeight: 20.0,
                            decoration: InputDecoration(
                              labelText: 'Enter password to save',
                              labelStyle: const TextStyle(color: Colors.black),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.teal,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(() => _showPassword = !_showPassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        const SizedBox(height: 30),

                        // Buttons - Fixed overflow
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Edit/Save Button - Reduced width
                            SizedBox(
                              width: 140, // Reduced from 150
                              child: ElevatedButton(
                                onPressed: _isEditing ? _saveProfile : () => setState(() => _isEditing = true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 6,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(_isEditing ? Icons.save : Icons.edit, size: 20),
                                    const SizedBox(width: 8), // Reduced spacing
                                    Text(
                                      _isEditing ? 'Save' : 'Edit',
                                      style: const TextStyle(
                                        fontSize: 16, // Reduced font size
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Reduced spacing

                            // Sign Out Button - Reduced width
                            SizedBox(
                              width: 140, // Reduced from 150
                              child: ElevatedButton(
                                onPressed: _signOut,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 6,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout, size: 20),
                                    SizedBox(width: 8), // Reduced spacing
                                    Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        fontSize: 16, // Reduced font size
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.teal,
      cursorWidth: 2.0,
      cursorHeight: 20.0,
      readOnly: !_isEditing,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(
          _getIconForField(label),
          color: Colors.teal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  IconData _getIconForField(String label) {
    switch (label) {
      case 'Full Name':
        return Icons.person;
      case 'Mobile':
        return Icons.phone;
      case 'Email':
        return Icons.email;
      case 'University':
        return Icons.school;
      default:
        return Icons.info;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
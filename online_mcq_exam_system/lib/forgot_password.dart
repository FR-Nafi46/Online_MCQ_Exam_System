import 'package:flutter/material.dart';
import 'supabase_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final SupabaseService _server = SupabaseService();

  bool _isLoading = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _accountVerified = false;
  String? _userId;

  final RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
  final RegExp mobileRegex = RegExp(r'^01[3-9]\d{8}$');
  final RegExp nameRegex = RegExp(r'^[a-zA-Z\s\.]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'Password Recovery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Align(
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
                        const Icon(Icons.lock_reset,
                            size: 60, color: Colors.teal),
                        const SizedBox(height: 15),
                        const Text(
                          'Password Recovery',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _accountVerified
                              ? 'Set your new password'
                              : 'Enter your name and mobile number to recover password',
                          style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (!_accountVerified) ...[
                                _buildTextField(
                                  controller: _nameController,
                                  label: 'Full Name',
                                  icon: Icons.person,
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Please enter your name';
                                    if (!nameRegex.hasMatch(value))
                                      return 'Name should not contain numbers';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildTextField(
                                  controller: _mobileController,
                                  label: 'Mobile Number',
                                  icon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Please enter mobile number';
                                    if (!mobileRegex.hasMatch(value))
                                      return 'Enter valid Bangladeshi number';
                                    return null;
                                  },
                                ),
                              ],
                              if (_accountVerified && _userId != null)
                                _buildVerifiedBadge(),
                              if (_accountVerified) ...[
                                const SizedBox(height: 20),
                                _buildPasswordField(
                                  controller: _newPasswordController,
                                  label: 'New Password',
                                  showPassword: _showNewPassword,
                                  onToggle: () => setState(
                                          () => _showNewPassword = !_showNewPassword),
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Please enter new password';
                                    if (value.length < 6)
                                      return 'Password must be at least 6 characters';
                                    if (!passwordRegex.hasMatch(value))
                                      return 'Must have: 1 uppercase, 1 lowercase, 1 number';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildPasswordField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirm New Password',
                                  showPassword: _showConfirmPassword,
                                  onToggle: () => setState(() =>
                                  _showConfirmPassword =
                                  !_showConfirmPassword),
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Please confirm new password';
                                    if (value != _newPasswordController.text)
                                      return 'Passwords do not match';
                                    return null;
                                  },
                                ),
                              ],
                              const SizedBox(height: 30),
                              _isLoading
                                  ? const CircularProgressIndicator(
                                  color: Colors.teal)
                                  : _buildActionButton(),
                              const SizedBox(height: 20),
                              _buildBackButton(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildRequirementsCard(),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool showPassword,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: const Icon(Icons.lock, color: Colors.teal),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          const Icon(Icons.verified, color: Colors.green, size: 30),
          const SizedBox(height: 10),
          const Text('Account Verified',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text('Student ID: ${_userId?.toUpperCase()}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal)),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: 230,
      child: ElevatedButton(
        onPressed: _accountVerified ? _resetPassword : _verifyAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_accountVerified ? Icons.lock_reset : Icons.verified_user,
                color: Colors.white),
            const SizedBox(width: 10),
            Text(_accountVerified ? 'Reset Password' : 'Verify Account',
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Text('Back to Login',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Password Requirements:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 8),
          _buildRequirement('At least 6 characters'),
          _buildRequirement('One uppercase & One lowercase'),
          _buildRequirement('One number (0-9)'),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 14),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  void _verifyAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = await _server.findUserByNameAndMobile(
          _nameController.text.trim(),
          _mobileController.text.trim(),
        );

        if (!mounted) return;

        if (user != null) {
          setState(() {
            _accountVerified = true;
            _userId = user['id'];
            _isLoading = false;
          });
          _showSnackBar('Account verified successfully!', Colors.green);
        } else {
          setState(() => _isLoading = false);
          _showSnackBar('No account found with these details', Colors.red);
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showSnackBar('Verification failed: $e', Colors.red);
      }
    }
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        bool success = await _server.resetPassword(
          _userId!,
          _newPasswordController.text,
        );

        if (!mounted) return;

        if (success) {
          setState(() => _isLoading = false);
          _showSnackBar('Password reset successfully!', Colors.green);
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) Navigator.pop(context);
        } else {
          setState(() => _isLoading = false);
          _showSnackBar('Password reset failed', Colors.red);
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showSnackBar('Reset failed: $e', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
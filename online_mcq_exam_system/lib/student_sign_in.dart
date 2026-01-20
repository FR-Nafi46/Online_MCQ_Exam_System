import 'dart:async';
import 'package:flutter/material.dart';
import 'student_home_page.dart';
import 'forgot_password.dart';
import 'supabase_service.dart';

class StudentSignInPage extends StatefulWidget {
const StudentSignInPage({super.key});

@override
State<StudentSignInPage> createState() => _StudentSignInPageState();
}

class _StudentSignInPageState extends State<StudentSignInPage> {
final _formKey = GlobalKey<FormState>();
final TextEditingController _idController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final SupabaseService _server = SupabaseService();

bool _isLoading = false;
bool _showPassword = false;

// Account lock state (local only)
bool _accountLocked = false;
int _failedAttempts = 0;
DateTime? _lockUntil;
Timer? _lockTimer;
String? _currentUserId;

@override
void initState() {
super.initState();
_startLockTimer();
}

@override
void dispose() {
// FIXED: Proper timer disposal
if (_lockTimer != null && _lockTimer!.isActive) {
_lockTimer!.cancel();
}
_idController.dispose();
_passwordController.dispose();
super.dispose();
}

// Periodically updates remaining lock time if account is locked
void _startLockTimer() {
// Cancel existing timer if any
if (_lockTimer != null && _lockTimer!.isActive) {
_lockTimer!.cancel();
}

_lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
if (_accountLocked && _lockUntil != null && mounted) {
final now = DateTime.now();
if (now.isAfter(_lockUntil!)) {
// Lock expired
setState(() {
_accountLocked = false;
_failedAttempts = 0;
_lockUntil = null;
_currentUserId = null;
});
}
}
});
}

// Check if account is locked (local check)
void _checkLocalLockStatus(String userId) {
if (_currentUserId == userId && _accountLocked) {
// Already locked for this user
return;
}

// Reset for different user
if (_currentUserId != userId) {
_currentUserId = userId;
_failedAttempts = 0;
_accountLocked = false;
_lockUntil = null;
}
}

// Record failed attempt and check if should lock
void _recordFailedAttempt(String userId) {
_failedAttempts++;

if (_failedAttempts >= 3) {
// Lock account for 1 hour
_accountLocked = true;
_lockUntil = DateTime.now().add(const Duration(hours: 1));

// Store lock info locally (you could also save to database)
_currentUserId = userId;

// Show lock message
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Account locked for 1 hour due to 3 failed attempts'),
backgroundColor: Colors.red,
duration: Duration(seconds: 3),
),
);
}
}

if (mounted) {
setState(() {});
}
}

// Reset failed attempts on successful login
void _resetFailedAttempts() {
_failedAttempts = 0;
_accountLocked = false;
_lockUntil = null;
if (mounted) {
setState(() {});
}
}

Duration? get _remainingLockTime {
if (_lockUntil == null) return null;
final diff = _lockUntil!.difference(DateTime.now());
return diff.isNegative ? Duration.zero : diff;
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey[100],
appBar: AppBar(
backgroundColor: Colors.teal,
foregroundColor: Colors.white,
title: const Text(
'Student Sign In',
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
const Text(
'Student Login',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.teal,
),
textAlign: TextAlign.center,
),
const SizedBox(height: 10),
const Text(
'Enter your credentials to continue',
style: TextStyle(fontSize: 14, color: Colors.grey),
),
const SizedBox(height: 25),

// Account locked message
if (_accountLocked && _remainingLockTime != null)
Container(
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: Colors.orange.withOpacity(0.1),
borderRadius: BorderRadius.circular(12),
border: Border.all(color: Colors.orange),
),
child: Column(
children: [
const Icon(
Icons.lock_clock,
color: Colors.orange,
size: 30,
),
const SizedBox(height: 10),
const Text(
'Account Temporarily Locked',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Colors.orange,
),
textAlign: TextAlign.center,
),
const SizedBox(height: 5),
Text(
'Try again in: ${_remainingLockTime!.inMinutes} min ${_remainingLockTime!.inSeconds % 60} sec',
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Colors.red,
),
textAlign: TextAlign.center,
),
],
),
),

if (_accountLocked) const SizedBox(height: 20),

Form(
key: _formKey,
child: Column(
children: [
// Student ID
TextFormField(
controller: _idController,
cursorColor: Colors.teal,
cursorWidth: 2.0,
cursorHeight: 20.0,
enabled: !_accountLocked,
onChanged: (value) {
if (value.isNotEmpty) {
_checkLocalLockStatus(value.trim().toLowerCase());
}
},
decoration: InputDecoration(
labelText: 'Student ID',
labelStyle: TextStyle(
color: _accountLocked ? Colors.grey : Colors.black,
),
prefixIcon: Icon(
Icons.badge,
color: _accountLocked ? Colors.grey : Colors.teal,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter your Student ID';
}
final normalized = value.trim().toLowerCase();
if (!RegExp(r'^stu\d{3}$').hasMatch(normalized)) {
return 'Invalid Student ID format. Must be like stu001';
}
return null;
},
),
const SizedBox(height: 20),

// Password
TextFormField(
controller: _passwordController,
obscureText: !_showPassword,
cursorColor: Colors.teal,
cursorWidth: 2.0,
cursorHeight: 20.0,
enabled: !_accountLocked,
decoration: InputDecoration(
labelText: 'Password',
labelStyle: TextStyle(
color: _accountLocked ? Colors.grey : Colors.black,
),
prefixIcon: Icon(
Icons.lock,
color: _accountLocked ? Colors.grey : Colors.teal,
),
suffixIcon: !_accountLocked
? IconButton(
icon: Icon(
_showPassword
? Icons.visibility
    : Icons.visibility_off,
color: Colors.grey,
),
onPressed: () {
setState(() {
_showPassword = !_showPassword;
});
},
)
    : null,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter your password';
}
return null;
},
),

if (_failedAttempts > 0 && !_accountLocked)
Padding(
padding: const EdgeInsets.only(top: 10),
child: Text(
'Failed attempts: $_failedAttempts/3',
style: TextStyle(
fontSize: 12,
color: _failedAttempts >= 2
? Colors.orange
    : Colors.grey,
fontWeight: _failedAttempts >= 2
? FontWeight.bold
    : FontWeight.normal,
),
),
),

const SizedBox(height: 30),

// Sign In Button
_isLoading
? const CircularProgressIndicator(color: Colors.teal)
    : SizedBox(
width: 230,
child: ElevatedButton(
onPressed: _accountLocked
? null
    : _signInStudent,
style: ElevatedButton.styleFrom(
backgroundColor:
_accountLocked ? Colors.grey : Colors.teal,
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
Icon(Icons.login),
SizedBox(width: 10),
Text(
'Sign In',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.w600,
),
),
],
),
),
),

const SizedBox(height: 15),

// Forgot Password
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Forgot Password?',
style: TextStyle(
fontSize: 13,
color: Colors.grey[700],
),
),
const SizedBox(width: 5),
GestureDetector(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
const ForgotPasswordPage()),
);
},
child: Text(
'Recover Now',
style: TextStyle(
fontSize: 13,
color: Colors.blue,
fontWeight: FontWeight.bold,
),
),
),
],
),
],
),
),

const SizedBox(height: 20),

// ID Info
Container(
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: Colors.grey[50],
borderRadius: BorderRadius.circular(12),
border: Border.all(color: Colors.grey),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Student ID Information:',
style: TextStyle(
fontWeight: FontWeight.bold,
color: Colors.teal,
),
),
const SizedBox(height: 8),
_buildInfo('Your ID starts with "stu" (e.g., stu001)'),
_buildInfo('Received during registration'),
_buildInfo('Case-insensitive (STU001 = stu001)'),
const SizedBox(height: 5),
const Text(
'Note: 3 failed attempts will lock account for 1 hour',
style: TextStyle(
fontSize: 11,
color: Colors.red,
fontStyle: FontStyle.italic,
),
),
],
),
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

Widget _buildInfo(String text) {
return Padding(
padding: const EdgeInsets.symmetric(vertical: 2),
child: Row(
children: [
const Icon(
Icons.info_outline,
color: Colors.teal,
size: 14,
),
const SizedBox(width: 8),
Text(
text,
style: const TextStyle(fontSize: 12, color: Colors.grey),
),
],
),
);
}

void _signInStudent() async {
if (_formKey.currentState!.validate()) {
setState(() => _isLoading = true);

// Normalize to lowercase for stu001 format
String userId = _idController.text.trim().toLowerCase();

// Check local lock status
_checkLocalLockStatus(userId);

if (_accountLocked) {
setState(() => _isLoading = false);
return;
}

try {
var user = await _server.loginStudent(userId, _passwordController.text);

if (user != null) {
// Successful login - reset failed attempts
_resetFailedAttempts();

setState(() => _isLoading = false);

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Welcome ${user['name']}!'),
backgroundColor: Colors.green,
duration: const Duration(seconds: 2),
),
);

Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) => const StudentHomePage()),
);
} else {
// Failed login
_recordFailedAttempt(userId);
setState(() => _isLoading = false);

if (_accountLocked) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Account locked for 1 hour due to 3 failed attempts'),
backgroundColor: Colors.red,
duration: Duration(seconds: 3),
),
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Invalid credentials. Attempts: $_failedAttempts/3'),
backgroundColor: Colors.orange,
duration: const Duration(seconds: 2),
),
);
}
}
} catch (e) {
setState(() => _isLoading = false);

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Login failed: $e'),
backgroundColor: Colors.red,
),
);
}
}
}
}

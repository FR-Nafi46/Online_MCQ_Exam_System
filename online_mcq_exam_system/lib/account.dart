import 'package:flutter/material.dart';
import 'student_sign_in.dart';
import 'teacher_home_page.dart';
import 'sign_up.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? selectedUserType;
  bool showStudentOptions = false;
  bool showTeacherOption = false;

  void _navigateToPage(String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $pageName'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Column(
                  children: [
                    Image.asset(
                      'assets/images/Logo_LU.png',
                      height: 200,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Welcome to Leading University Learning Portal',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),


                const SizedBox(height: 8),

                const Text(
                  'Choose your role to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 35),

                // main box design...!

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

                        // Teacher and Student Button...

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildUserTypeButton(
                              icon: Icons.school,
                              label: 'Student',
                              color: Colors.blue,
                              isSelected: selectedUserType == 'student',
                              onPressed: () {
                                setState(() {
                                  selectedUserType = 'student';
                                  showStudentOptions = true;
                                  showTeacherOption = false;
                                });
                              },
                            ),

                            const SizedBox(width: 20),

                            _buildUserTypeButton(
                              icon: Icons.person,
                              label: 'Teacher',
                              color: Colors.green,
                              isSelected: selectedUserType == 'teacher',
                              onPressed: () {
                                setState(() {
                                  selectedUserType = 'teacher';
                                  showTeacherOption = true;
                                  showStudentOptions = false;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        if (showStudentOptions) ...[
                          _buildActionButton(
                            text: 'Sign In',
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const StudentSignInPage()),
                              );
                            },
                            icon: Icons.login,
                          ),

                          const SizedBox(height: 15),

                          _buildActionButton(
                            text: 'Sign Up',
                            color: Colors.teal,
                            icon: Icons.app_registration,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              );
                            },
                          ),
                        ],

                        if (showTeacherOption) ...[
                          _buildActionButton(
                            text: 'Sign In',
                            color: Colors.green,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TeacherSignIn()),
                              );
                            },
                            icon: Icons.login,
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'Teacher registration requires admin approval.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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

  // Box design...teacher and stu
  Widget _buildUserTypeButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 55,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sign in and sign up er Button !

  Widget _buildActionButton({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 230,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
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
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

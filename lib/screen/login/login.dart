import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/screen/signup/signup.dart';
import 'package:my_app_flutter_1/api/firebase_api.dart';
import 'package:my_app_flutter_1/screen/menu/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: LoginScreenStateful(),
    );
  }
}

class LoginScreenStateful extends StatefulWidget {
  const LoginScreenStateful({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenStateful> {
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> _saveLoginTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('login_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.teal),
          ),
          content: Text(
            errorMessage,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when login starts
      });

      await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = _authService.getCurrentUserUid();
      if (uid != null) {
        prefs.setString('uid', uid);
        _saveLoginTimestamp(); // Save login timestamp

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      } else {
        _showErrorDialog(context, 'Failed to get user information.');
      }
    } catch (e) {
      print('Login error: $e');
      _showErrorDialog(
          context, 'Login failed. Check your email/username and password.');
    } finally {
      setState(() {
        isLoading = false; // Set loading to false when login completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/logo.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Login to your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: <Widget>[
                    NormalField(
                      label: "Email",
                      icon: Icons.email,
                      controller: emailController,
                    ),
                    const SizedBox(height: 10),
                    PasswordField(
                      label: "Password",
                      obscureText: !isPasswordVisible,
                      icon: Icons.lock,
                      onToggleVisibility: () {},
                      controller: passwordController,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.teal.shade700],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      // Periksa apakah kedua bidang diisi sebelum melanjutkan
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        _showErrorDialog(context, 'Please fill in all fields.');
                      } else {
                        // Lanjutkan dengan proses login jika sudah diisi
                        _login();
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        " Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

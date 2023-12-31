import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/screen/signup/signup.dart';
import 'package:my_app_flutter_1/api/firebase_api.dart';
import 'package:my_app_flutter_1/screen/menu/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == true) {
            return MyHomePage();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    int? loginTimestamp = prefs.getInt('login_timestamp');

    if (uid != null && loginTimestamp != null) {
      int validityDurationSeconds = 7 * 24 * 60 * 60; // 7 days validity
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

      if (currentTimestamp - loginTimestamp < validityDurationSeconds * 1000) {
        return true;
      }
    }

    return false;
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: LoginScreenStateful(),
    );
  }
}

class LoginScreenStateful extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenStateful> {
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _saveLoginTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('login_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(color: Colors.teal),
          ),
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/logo.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                SizedBox(height: 10),
                Text(
                  "Login to your account",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Column(
              children: <Widget>[
                NormalField(
                  label: "Email",
                  icon: Icons.email,
                  controller: emailController,
                ),
                SizedBox(height: 10),
                PasswordField(
                  label: "Password",
                  obscureText: !isPasswordVisible,
                  icon: Icons.lock,
                  onToggleVisibility: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  controller: passwordController,
                ),
              ],
            ),
            SizedBox(
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
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

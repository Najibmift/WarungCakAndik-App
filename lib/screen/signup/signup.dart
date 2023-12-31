import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app_flutter_1/screen/login/login.dart';
import 'package:my_app_flutter_1/api/firebase_api.dart';

class SignupScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  Future<void> onPressedSignUp(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        // Validate form fields

        // Check if password and confirm password match
        if (passwordController.text != confirmController.text) {
          _showErrorDialog(
            context,
            'Password and Confirm Password must match.',
          );
          return;
        }

        // Check if password is at least 6 characters
        if (passwordController.text.length < 6) {
          _showErrorDialog(
            context,
            'Password must be at least 6 characters long.',
          );
          return;
        }

        // Check if the username is already taken
        bool isUsernameTaken =
            await isUsernameAlreadyTaken(usernameController.text);
        if (isUsernameTaken) {
          _showErrorDialog(
            context,
            'The entered username is already taken. Please choose another one.',
          );
          return;
        }

        // Call the signup method
        await _authService.signUp(
          emailController.text.trim(),
          passwordController.text,
          usernameController.text,
        );

        // Show success dialog
        _showSuccessDialog(context);

        // Delay for a moment to let the success dialog display
        await Future.delayed(Duration(seconds: 2));

        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    } catch (e) {
      _handleSignUpError(context, e);
    }
  }

  Future<bool> isUsernameAlreadyTaken(String username) async {
    try {
      // Check if the username is already taken in Cloud Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username availability: $e');
      throw e;
    }
  }

  Future<void> saveUserInfo(String email, String username) async {
    try {
      // Save user info to Cloud Firestore
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'email': email,
        'username': username,
        // ... add other fields as needed
      });
    } catch (e) {
      print('Error saving user info: $e');
      throw e;
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Success',
            style: TextStyle(color: Colors.teal),
          ),
          content: Text(
            'Registration successful!',
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

  void _handleSignUpError(BuildContext context, dynamic error) {
    String errorMessage = 'An error occurred during signup. Please try again.';

    if (error is FirebaseAuthException) {
      if (error.code == 'email-already-in-use') {
        errorMessage = 'The entered email is already registered.';
      } else {
        errorMessage = 'Error: ${error.message}';
      }
    }

    _showErrorDialog(context, errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.teal,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/assets/logo.png"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create an account, It's free ",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        NormalField(
                          label: "Username",
                          icon: Icons.person,
                          controller: usernameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        NormalField(
                          label: "Email",
                          icon: Icons.email,
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        PasswordField(
                          label: "Password",
                          obscureText: true,
                          icon: Icons.lock,
                          onToggleVisibility: () {},
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        PasswordField(
                          label: "Confirm Password",
                          obscureText: true,
                          icon: Icons.lock,
                          onToggleVisibility: () {},
                          controller: confirmController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm Password is required';
                            }
                            return null;
                          },
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
                          _formKey.currentState!.save(); // Save the form state
                          onPressedSignUp(context);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Sign Up",
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
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account?"),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              " Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NormalField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const NormalField({
    Key? key,
    required this.label,
    this.icon,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _NormalFieldState createState() => _NormalFieldState();
}

class _NormalFieldState extends State<NormalField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            labelText: widget.label,
            labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.grey[600],
            ),
            fillColor: Colors.grey.shade200,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          ),
          validator: widget.validator,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final IconData? icon;
  final VoidCallback? onToggleVisibility;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.icon,
    this.onToggleVisibility,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            filled: true,
            labelText: widget.label,
            labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.grey[600],
            ),
            fillColor: Colors.grey.shade200,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: () {
                      widget.onToggleVisibility!();
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: isPasswordVisible ? Colors.grey : null,
                    ),
                  )
                : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}

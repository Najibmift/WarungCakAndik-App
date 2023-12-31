import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/screen/signup/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
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
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/logo.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Login to your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    NormalField(
                      label: "Email",
                      icon: Icons.email,
                    ),
                    SizedBox(height: 10),
                    PasswordField(
                      label: "Password",
                      obscureText: true,
                      icon: Icons.lock,
                      onToggleVisibility: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: 25),
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
                        onPressed: () {},
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
                    SizedBox(height: 20),
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
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NormalField extends StatefulWidget {
  final String label;
  final IconData? icon;

  const NormalField({
    Key? key,
    required this.label,
    this.icon,
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
        TextField(
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

  const PasswordField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.icon,
    this.onToggleVisibility,
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
        TextField(
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
        ),
      ],
    );
  }
}

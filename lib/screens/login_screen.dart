import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ams_employees/constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final _emailTextController = TextEditingController();
  final _pwdTextController = TextEditingController();

  bool _validateEmail = false;
  bool _validatePassword = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _pwdTextController.dispose();
    super.dispose();
  }

  void _sendPasswordResetEmail() async {
    if (_emailTextController.text.isEmpty) {
      await _showErrorMessage("Please enter your email.");
      return;
    }

    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(120.0),
              child: LoadingIndicator(
                indicatorType: Indicator.cubeTransition,
                colors: [Colors.white, Color(0xFFD1000B)],
              ),
            ),
          );
        },
      );

      await _auth.sendPasswordResetEmail(email: _emailTextController.text);

      Navigator.pop(context);

      await _showErrorMessage(
          "Password reset email has been sent to your email address. Please check your inbox and follow the instructions to reset your password.");
    } on PlatformException catch (e) {
      print("Error: $e");
      await _showErrorMessage(
          "Failed to send password reset email. Please try again later.");
      Navigator.pop(context);
    }
  }

  Future<void> _showErrorMessage(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Stack(
                children: [
                  Hero(
                    tag: 'login_bg',
                    child: Image(
                      image: AssetImage('assets/images/login_bg.png'),
                      fit: BoxFit.fitWidth,
                      width: 1000,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Hero(
                      tag: 'logo',
                      child: Image(
                        image: AssetImage('assets/images/wb_logo.png'),
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Welcome Back!",
                        style: kHeadingTextStyle,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Please enter your details",
                        style: kSubHeadingTextStyle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Email', style: kTextFieldTextStyle),
                    TextField(
                      controller: _emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          _validateEmail = false;
                        });
                      },
                      style: kTextFieldTextStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        errorText:
                            _validateEmail ? 'Email Can\'t Be Empty' : null,
                        hintText: 'Enter your email here.',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Password', style: kTextFieldTextStyle),
                    TextField(
                      controller: _pwdTextController,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          _validatePassword = false;
                        });
                      },
                      style: kTextFieldTextStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        errorText: _validatePassword
                            ? 'Password Can\'t Be Empty'
                            : null,
                        hintText: 'Enter your password here.',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _sendPasswordResetEmail,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(
                            'Forgot Password?',
                            style: kForgetPasswordTextStyle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _emailTextController.text.isEmpty
                              ? _validateEmail = true
                              : _validateEmail = false;
                          _pwdTextController.text.isEmpty
                              ? _validatePassword = true
                              : _validatePassword = false;
                        });

                        if (!_validateEmail && !_validatePassword) {
                          try {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(120.0),
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.cubeTransition,
                                      colors: [Colors.white, Color(0xFFD1000B)],
                                    ),
                                  ),
                                );
                              },
                            );

                            final userCredential =
                                await _auth.signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _pwdTextController.text,
                            );

                            Navigator.pop(context);

                            if (userCredential.user != null) {
                              Navigator.pushNamed(context, '/dashboard');
                            } else {
                              await _showErrorMessage(
                                  "Invalid credentials. Please check your email and password.");
                            }
                          } on FirebaseAuthException catch (e) {
                            String errorMessage = "";
                            if (e.code == 'user-not-found') {
                              errorMessage =
                                  "User not found. Please check your email.";
                            } else if (e.code == 'wrong-password') {
                              errorMessage =
                                  "Invalid password. Please check your password.";
                            } else if (e.code == 'invalid-email') {
                              errorMessage =
                                  "Invalid email. Please enter a valid email.";
                            } else {
                              errorMessage = "Login failed. Internet Issue.";
                            }
                            await _showErrorMessage(errorMessage);
                            Navigator.pop(context);
                          } catch (e) {
                            print("Error: $e");
                            await _showErrorMessage(
                                "Login failed 2. Please try again later.");
                            Navigator.pop(context);
                          }
                        }
                      },
                      style: kElevatedButtonStyle,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Login',
                          style: kButtonTextStyle,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'I don\'t have an account?',
                          style: kLoginSignupOptionTextStyle,
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                'SignUp',
                                style: kBottomLoginSignupTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

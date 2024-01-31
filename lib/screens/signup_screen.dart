import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ams_employees/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:intl/intl.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  final CollectionReference<Map<String, dynamic>> profileCollection =
      FirebaseFirestore.instance.collection('Employee');

  Stream<QuerySnapshot<Map<String, dynamic>>> getAttendanceStream() {
    return profileCollection.snapshots();
  }

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _auth = FirebaseAuth.instance;
  final _emailTextController = TextEditingController();
  final _pwdTextController = TextEditingController();
  final _cpwdTextController = TextEditingController();

  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _validateConfirmPassword = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  late final newUser;

  @override
  void dispose() {
    _emailTextController.dispose();
    _pwdTextController.dispose();
    _cpwdTextController.dispose();
    super.dispose();
  }

  void _onGoogleSignInPressed() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          Navigator.pushNamed(context, '/dashboard');

          Map<String, dynamic> userMap = {
            'email': user.email,
          };
        } else {
          _showErrorMessage("Failed to sign in with Google. Please try again.");
        }
      } else {}
    } catch (e) {}
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
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    void onSignupPressed() async {
      final user = _auth.currentUser;
      if (user != null) {
        final userEmail = user.email;
        final userName = userEmail?.substring(0, userEmail.indexOf('@'));
        final docReference = firestore
            .collection('Employee')
            .doc('$userName')
            .collection('EmployeeProfile')
            .doc('ProfileDetails');

        await docReference.set(
          {
            'Name': userName,
            'ID': 'W-{$userName}',
            'Email': userEmail,
          },
          SetOptions(merge: true),
        );

        // setState(() {
        //   isCheckedIn = true;
        //   checkInDateTime = DateTime.now();
        // });
      }
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Stack(
                children: [
                  Hero(
                    tag: 'login_bg',
                    child: Image(
                      image: AssetImage('assets/images/login_bg.png'),
                      height: 250,
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
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Create Your Account",
                          style: kHeadingTextStyle,
                        ),
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
                      obscureText: !_passwordVisible,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Confirm Password', style: kTextFieldTextStyle),
                    TextField(
                      controller: _cpwdTextController,
                      obscureText: !_confirmPasswordVisible,
                      onChanged: (value) {
                        setState(() {
                          _validateConfirmPassword = false;
                        });
                      },
                      style: kTextFieldTextStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        errorText: _validateConfirmPassword
                            ? 'Password Can\'t Be Empty'
                            : null,
                        hintText: 'Confirm your password.',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _emailTextController.text.isEmpty
                              ? _validateEmail = true
                              : _validateEmail = false;
                          _pwdTextController.text.isEmpty
                              ? _validatePassword = true
                              : _validatePassword = false;
                          _cpwdTextController.text.isEmpty
                              ? _validateConfirmPassword = true
                              : _validateConfirmPassword = false;
                        });

                        if (!_validateEmail &&
                            !_validatePassword &&
                            !_validateConfirmPassword) {
                          if (_pwdTextController.text !=
                              _cpwdTextController.text) {
                            await _showErrorMessage("Passwords do not match");
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

                            newUser =
                                await _auth.createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _pwdTextController.text,
                            );

                            Navigator.of(context).pop();
                            onSignupPressed();
                            Navigator.pushNamed(context, '/dashboard');
                            Map<String, dynamic> userMap = {
                              'email': _emailTextController.text,
                            };
                          } catch (e) {
                            String errorMessage = 'An error occurred';
                            if (e is FirebaseAuthException) {
                              switch (e.code) {
                                case 'email-already-in-use':
                                  errorMessage = 'Email already in use';
                                  break;
                                case 'weak-password':
                                  errorMessage = 'Password is too weak';
                                  break;
                                default:
                                  errorMessage = e.message ?? errorMessage;
                              }
                            }
                            await _showErrorMessage(errorMessage);
                            Navigator.pop(context);
                          }
                        }
                      },
                      style: kElevatedButtonStyle,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'SignUp',
                          style: kButtonTextStyle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            'or continue with',
                            style: kDividerTextStyle,
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        _onGoogleSignInPressed();
                      },
                      style: kElevatedButtonStyle.copyWith(
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Color(0x33FFFFFF),
                            ),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/google.png'),
                            fit: BoxFit.fitWidth,
                            width: 25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Google',
                            style: kGoogleButtonTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: kLoginSignupOptionTextStyle,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Login',
                              style: kBottomLoginSignupTextStyle,
                            ),
                          ),
                        )
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

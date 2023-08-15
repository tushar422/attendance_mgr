import 'package:attendance_mgr/util/validator.dart';
import 'package:attendance_mgr/widget/ui/raised_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginMode {
  login,
  signup,
}

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.mode});

  final LoginMode mode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginForm = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  String _emailEntered = '';
  String _enteredPassword = '';
  LoginMode _mode = LoginMode.login;
  bool _submitting = false;
  @override
  void initState() {
    setState(() {
      _mode = widget.mode;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: _nextPressed,
        child: (_submitting)
            ? const CircularProgressIndicator()
            : const Icon(Icons.navigate_next),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Form(
          key: _loginForm,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 50),
                  child: Text(
                    (_mode == LoginMode.login) ? 'Sign In' : 'Signup',
                    style: GoogleFonts.raleway(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                RaisedFormField(
                  controller: _emailController,
                  label: 'E-Mail',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.alternate_email),
                ),
                const SizedBox(height: 20),
                RaisedFormField(
                  controller: _passwordController,
                  label: 'Password',
                  visibilityButtonEnabled: true,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.password),
                ),
                const SizedBox(height: 20),
                if (_mode == LoginMode.signup)
                  RaisedFormField(
                    controller: _passwordConfirmController,
                    label: 'Repeat Password',
                    visibilityButtonEnabled: true,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.password),
                  ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _mode = (_mode == LoginMode.login)
                          ? LoginMode.signup
                          : LoginMode.login;
                    });
                  },
                  child: Text((_mode == LoginMode.login)
                      ? 'Sign up instead.'
                      : 'Log in instead.'),
                ),
                // const SizedBox(height: 25),
                // Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _nextPressed() {
    _emailEntered = _emailController.text.trim();
    _enteredPassword = _passwordController.text.trim();
    final confirmPass = (_mode == LoginMode.login)
        ? _enteredPassword
        : _passwordConfirmController.text.trim();

    final emailValidation = validateEmail(_emailEntered);
    final passValidation = validatePassword(_enteredPassword) ??
        ((_enteredPassword == confirmPass) ? null : 'Passwords don\'t match');
    if (emailValidation == null && passValidation == null)
      _action();
    else {
      _showWarning('${emailValidation ?? ''}\n${passValidation ?? ''}');
    }
  }

  void _action() async {
    setState(() {
      _submitting = true;
    });

    try {
      final cred = (_mode == LoginMode.signup)
          ? await _firebase.createUserWithEmailAndPassword(
              email: _emailEntered, password: _enteredPassword)
          : await _firebase.signInWithEmailAndPassword(
              email: _emailEntered, password: _enteredPassword);
    } on FirebaseAuthException catch (e) {
      print('hi');
      _showWarning(e.code);
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }

  void _showWarning(String label) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.warning),
          content: Text(label),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }
}

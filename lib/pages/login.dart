import 'package:chargehub/pages/ev_home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repeated/button.dart';
import '../services/error_handler.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 2, 75, 1.0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 300,
              height: 300,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset("assets/images/chargeHub.png"),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Welcome to ChargeHub',
              style: TextStyle(
                fontSize: 27,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'font1',
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Center(
            child: Text(
              'Log in to see located ',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'font1',
              ),
            ),
          ),
          const Center(
            child: Text(
              'EV Charging and Gas Stations',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'font1',
              ),
            ),
          ),
          const SizedBox(height: 50),
          // Username Input Field with Icon
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: _usernameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Colors.black),
                // Username icon
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelText: 'Username',
                hintText: 'Enter your name...',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'font1',
                ),
              ),
            ),
          ),
          // Email Input Field with Icon
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.black),
                // Email icon
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelText: 'Email',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'font1',
                ),
                hintText: 'Enter Email...',
              ),
            ),
          ),
          // Password Input Field with Icon
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                // Password icon
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'font1',
                ),
                hintText: 'Enter Password...',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: btnCal(c: Colors.blue, text: "Log in", event: _login),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUp(); // Navigate to Sign-up page
                      },
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'You do not have an account?',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: '  Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Form validation
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ErrorHandler.showWarningSnackbar(context, 'Please fill in all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      ErrorHandler.showWarningSnackbar(
        context,
        'Please enter a valid email address',
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        ErrorHandler.showSuccessSnackbar(context, 'Login successful!');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage(username: username)),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSignUpPrompt();
      } else {
        AppError error = ErrorHandler.handleFirebaseAuthError(e);
        ErrorHandler.showErrorDialog(context, error);
      }
    } catch (e) {
      AppError error = ErrorHandler.handleGeneralError(e);
      ErrorHandler.showErrorDialog(context, error);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSignUpPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(34, 37, 45, 1),
          title: const Text(
            'No Account Found',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'No account found for this email. Would you like to sign up?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}

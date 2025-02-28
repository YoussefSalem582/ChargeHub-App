import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repeated/button.dart'; // Assuming this is a custom button widget
import 'login.dart'; // Importing the login page

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

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
      backgroundColor: const Color.fromRGBO(31, 2, 75, 1.0), // Same background as login page
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
                fit: BoxFit.cover, // Same image fitting style
                child: Image.asset("assets/images/chargeHub.png"),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Sign Up now For Free!',
              style: TextStyle(
                fontSize: 27,
                color: Colors.white, // White text to match login
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, // Italic to match login style
                fontFamily: 'font1'
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Center(
            child: Text(
              'Create new ChargeHub account',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                  fontFamily: 'font1'
              ),
            ),
          ),
          const Center(
            child: Text(
              'and join the family!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                  fontFamily: 'font1'
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
                prefixIcon: const Icon(Icons.person, color: Colors.black), // Username icon
                filled: true,
                fillColor: const Color(0xFFFFFFFF), // White field background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelText: 'Username',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'font1',
                ),
                hintText: 'Enter your name...',
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
                prefixIcon: const Icon(Icons.email, color: Colors.black), // Email icon
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
                prefixIcon: const Icon(Icons.lock, color: Colors.black), // Password icon
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
            child: btnCal(
              c: Colors.blue, // Blue button color to match login
              text: "Sign Up",
              event: _signUp,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return Login(); // Navigate to the Login page
                      },
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Do you have an existing account?',
                    style: TextStyle(
                      color: Colors.white, // White text color
                      fontSize: 16.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '  Login',
                        style: TextStyle(
                          color: Colors.blue, // Blue text with underline
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

  void _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign Up Successful')),
        );
        // Navigate to the home page or perform other actions
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }
}

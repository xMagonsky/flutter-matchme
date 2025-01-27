import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flat_match/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _register() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final firestore = FirebaseFirestore.instance;
    
    if (_passwordController.text.trim() !=  _passwordRepeatController.text.trim()) {
      setState(() {
        _errorMessage = "Passwords don't match.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      await authProvider.signUp(_emailController.text.trim(), _passwordController.text.trim());

      final uid = authProvider.uid;
      if (uid != null) {
        await firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      setState(() {
        final errorString = e.toString();

        if (errorString.contains("missing-email")) {
          _errorMessage = "Please provide an email address.";
        } else if (errorString.contains("invalid-email")) {
          _errorMessage = "Invalid email address.";
        } else if (errorString.contains("email-already-in-use")) {
          _errorMessage = "This email is already in use. Please try another one.";
        } else if (errorString.contains("weak-password")) {
          _errorMessage = "Your password is too weak. Please choose a stronger one.";
        } else if (errorString.contains("password")) {
          _errorMessage = "Please provide a password.";
        } else {
          _errorMessage = errorString;
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create a new account")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordRepeatController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Repeat password",
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text("Register"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

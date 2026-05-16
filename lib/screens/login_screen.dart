import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; 
import '../services/expense_provider.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;
  bool _isLoginMode = true; 
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; 

  // --- FUNCTION 1: SUBMIT AUTH ---
  Future<void> _submitAuth() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      
      if (mounted) {
        Provider.of<ExpenseProvider>(context, listen: false).loadExpenses();
        Navigator.pushReplacementNamed(context, '/home');
      }
      
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  } // <--- NOTICE THIS CLOSING BRACE! _submitAuth ends here.

  // --- FUNCTION 2: RESET PASSWORD (Bonus) ---
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    
    // 1. Check if they actually typed an email
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address in the box first.')),
      );
      return;
    }

    // 2. Ask Firebase to send the email
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: Colors.green, 
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Failed to send reset email.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } // <--- _resetPassword ends here.

  // --- FUNCTION 3: THE UI BUILDER ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Image.asset('assets/images/logo.png', height: 100),
            const SizedBox(height: 16),
            Text(_isLoginMode ? 'Welcome Back' : 'Create Account', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _isPasswordHidden,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordHidden ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                ),
              ),
            ),

            if (_isLoginMode)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: const Text('Forgot Password?'),
                ),
              ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitAuth,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(_isLoginMode ? 'Login' : 'Register'),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
              child: Text(_isLoginMode ? 'Need an account? Register here.' : 'Already have an account? Login.'),
            )
          ],
        ),
      ),
    );
  }
}
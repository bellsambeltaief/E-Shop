import 'package:e_shop/services/firebase_auth_service.dart';
import 'package:e_shop/widgets/button.dart';
import 'package:e_shop/widgets/header.dart';
import 'package:e_shop/widgets/no_account.dart';
import 'package:e_shop/widgets/products.dart';
import 'package:e_shop/widgets/sign_up.dart';
import 'package:e_shop/widgets/text_field.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  void _logIn() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      try {
        final user = await _auth.signInWithEmailAndPassword(email, password);
        if (user != null) {
          // Connexion réussie
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Products(),
            ),
          );
        } else {
          setState(() {
            errorMessage = 'User not found';
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Login error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 50.0),
                  const Header(text: 'Please login in order to proceed'),
                  const SizedBox(height: 50.0),
                  TextFileds(
                    controller: emailController,
                    label: "Email",
                    obscure: false,
                    input: TextInputType.emailAddress,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFileds(
                    controller: passwordController,
                    label: "Password",
                    obscure: true,
                    input: TextInputType.visiblePassword,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Button(
                    label: "Sign In",
                    onTap: _logIn,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  NoAccount(
                    text1: 'You don\'t have an account ? ',
                    text2: "Sign Up",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SignUp(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

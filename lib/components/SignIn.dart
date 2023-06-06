import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/components/ClearableSecureTextField.dart';
import 'package:social/components/ClearableTextField.dart';
import 'package:social/controllers/AuthController.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }

    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      print('Form submitted');

      final email = _emailController.text;
      final password = _passwordController.text;

      AuthController.login(email, password).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  bool termsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ClearableTextFormField(
                controller: _emailController,
                label: "Email",
                placeholder: "Email",
                prefix: Icon(CupertinoIcons.mail),
                validator: _validateEmail,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey,
                      width: 1,
                    ),
                  ),
                )),
            ClearableSecureTextField(
                controller: _passwordController,
                label: "Password",
                placeholder: "Password",
                validator: _validatePassword,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey,
                      width: 1,
                    ),
                  ),
                )),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Sign in'),
            ),
            ElevatedButton(
              onPressed: () {
                AuthController.logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/components/ClearableSecureTextField.dart';
import 'package:social/components/ClearableTextField.dart';
import 'package:http/http.dart' as http;
import 'package:social/controllers/AuthController.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name.';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters long.';
    }
    return null;
  }

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

  Future<String?> _validateUsername(String? value) async {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }
    final nameRegex = RegExp(r'^[a-zA-Z0-9_.-]{2,}$');
    if (!nameRegex.hasMatch(value)) {
      return 'Usernames can only include letters, numbers and the following characters: _ - and . ';
    }

    var url = Uri.parse('https://localhost:8000/users/username/$value');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return 'Username already exists.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }

    RegExp passwordRegex =
        RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");

    if (!passwordRegex.hasMatch(value)) {
      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    final password = _passwordController.value.text;
    if (password.isEmpty) {
      return 'Please enter a password.';
    }

    if (value != password) {
      return 'Passwords do not match.';
    }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      print('Form submitted');

      final name = _nameController.text;
      final email = _emailController.text;
      final username = _usernameController.text;
      final password = _passwordController.text;

      AuthController.register(name, email, username, password, domHand == "Right")
          .then((value) => {Navigator.pop(context)})
          .catchError((error) => {print(error)});
    }
  }

  String domHand = 'Right';

  bool termsChecked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ClearableTextFormField(
                controller: _nameController,
                label: "Name",
                placeholder: "Name",
                prefix: Icon(CupertinoIcons.person_fill),
                validator: _validateName,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey,
                      width: 1,
                    ),
                  ),
                )),
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
            ClearableTextFormField(
                controller: _usernameController,
                label: "Username",
                placeholder: "Username",
                prefix: Icon(CupertinoIcons.at),
                validator: _validateUsername,
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
            ClearableSecureTextField(
                controller: _confirmPasswordController,
                label: "Confirm Password",
                placeholder: "Password",
                validator: _validateConfirmPassword,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey,
                      width: 1,
                    ),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Text("Dominand Hand"),
              DropdownButton(
                // Initial Value
                value: domHand,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: ["Right", "Left"].map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    domHand = newValue!;
                  });
                },
              )
            ]),
            GestureDetector(
                onTap: () => {
                      setState(() {
                        termsChecked = !termsChecked;
                      })
                    },
                child: CupertinoFormRow(
                    child: Row(children: [
                  Checkbox(
                      value: termsChecked,
                      onChanged: (e) => {
                            setState(() {
                              termsChecked = !termsChecked;
                            })
                          }),
                  const Text(
                    "By creating an account, you agree to \nour Terms of Service and Privacy Policy. ",
                    maxLines: 3,
                  ),
                ]))),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

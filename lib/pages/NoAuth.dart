import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/components/Register.dart';
import 'package:social/components/SignIn.dart';

class NoAuth extends StatefulWidget {
  const NoAuth({Key? key}) : super(key: key);

  @override
  State<NoAuth> createState() => _NoAuthState();
}

class _NoAuthState extends State<NoAuth> {

  final List<Text> segments = [
    Text("Login"),
    Text("Register")
  ];

  late Text selected;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            children: [
              CupertinoSegmentedControl<int>(
                children: {
                  0: Text('Login'),
                  1: Text('Register'),
                },
                groupValue: selectedIndex,
                onValueChanged: (value) {
                  setState(() {
                    selectedIndex = value!;
                    print(selectedIndex); // 0 or 1
                  });
                },
              ),
              selectedIndex == 0 ? const SignIn() : const Register(),
            ],
          ),
        ),
      ),
    );
  }

}

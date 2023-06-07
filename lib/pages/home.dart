import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/controllers/AuthController.dart';
import 'package:social/pages/NoAuth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _counter = 0;
  final auth = FirebaseAuth.instance;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: CupertinoTheme.of(context).textTheme.textStyle,
            ),
            auth.currentUser != null ?
            CupertinoButton.filled(
              onPressed: () async {
                await AuthController.logout();
                setState(() {

                });
              },
              child: Text('Sign Out'),
            )  :
            CupertinoButton.filled(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NoAuth()),
                );
              },
              child: Text('Get Connected'),
            ),
          ],
        ),
      ),
    );
  }
}

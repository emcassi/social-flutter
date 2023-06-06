import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:social/pages/AddPost.dart';
import 'package:social/pages/Browse.dart';
import 'package:social/pages/Home.dart';
import 'package:social/pages/MyProfile.dart';
import 'package:social/pages/NoAuth.dart';
import 'package:social/pages/Notifications.dart';
import 'package:social/providers/user_provider.dart';
import 'package:social/types/user.dart';

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  late UserProvider _userProvider;

  int selectedTab = 0;

  Widget getBody() {
    switch (selectedTab) {
      case 0:
        return const Home();
      case 1:
        return const Browse();
      case 2:
        return Container();
      case 3:
        return const Notifications();
      case 4:
        return const MyProfile();
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
      });
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoAuth()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          // make the bottom navigation bar blue
          backgroundColor: Colors.blue,
          elevation: 20,
          unselectedItemColor: CupertinoColors.systemGrey,
          selectedItemColor: CupertinoColors.black,
          currentIndex: selectedTab,
          onTap: (int index) {
            setState(() {
              if(index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const AddPost()));
              } else {
                selectedTab = index;
              }
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        body: getBody(),
      ),
    );
  }
}

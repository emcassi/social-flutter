import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/components/post_view.dart';
import 'package:social/controllers/AuthController.dart';
import 'package:social/pages/NoAuth.dart';
import 'package:social/types/post.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final auth = FirebaseAuth.instance;

  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    AuthController.getFeed().then((value) =>
      setState(() {
        _posts = value;
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text('Twinstagram', style: TextStyle(fontFamily: "cursive", fontSize: 28),),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          if(_posts.length == 0) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return PostView(post: _posts[index]);
          }
      },
    ));
  }
}

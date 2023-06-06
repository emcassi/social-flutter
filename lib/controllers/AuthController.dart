import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'package:social/types/post.dart';
import 'package:social/types/user.dart';

class AuthController {
  static Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> register(String name, String email, String username, String password, bool rightHanded) async {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) async => {
        await FirebaseFirestore.instance.collection("users").doc(value.user!.uid).set({
          "name": name,
          "email": email,
          "username": username,
          "rightHanded": rightHanded,
        }).catchError((error) => {
          print(error)
        })
      });

      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut().catchError((e) => {print(e)});
  }

  static Future<List<Post>> getPosts(String uid) async {
    List<Post> list = [];

    final user = await SocialUser.fromFirebase(uid);
    if (user == null) {
      throw Exception("User not found");
      return [];
    }

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(uid).collection("posts").orderBy(
      "timestamp",
      descending: true,
    ).get();
    for (var doc in query.docs) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        final text = data['text'];
        final timestamp = data['timestamp'].toDate();
        final imageUrl = data['image'];

        SocialUser? user = await SocialUser.fromFirebase(uid);
        if (user == null) {
          throw Exception("User not found");
        }

        list.add(Post(id: doc.id, text: text, timestamp: timestamp, user: user, imageUrl: imageUrl));
      }
    }
    return list;
  }
}
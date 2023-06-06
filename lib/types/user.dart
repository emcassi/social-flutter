import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialUser {
  String uid;
  String name;
  String email;
  String username;
  DateTime joined;
  String? aviUrl;
  String? bio;
  String? website;

  SocialUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.joined,
    this.aviUrl,
    this.bio,
    this.website,
  });

  static Future<SocialUser?> fromFirebase(String uid) async {
    SocialUser? suser = null;
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      if (!value.exists) {
        suser = null;
      } else {
        suser = SocialUser(
          uid: uid,
          name: value.data()?['name'],
          email: value.data()?['email'],
          username: value.data()?['username'],
          joined: value.data()?['joined'].toDate(),
          bio: value.data()?['bio'],
          website: value.data()?['website'],
          aviUrl: value.data()?['aviUrl'],
        );
      }
    }).catchError((error) {
      print("ERROR: " + error);
      suser = null;
    });
    return suser;
  }
}
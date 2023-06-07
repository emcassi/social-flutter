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
      throw e;
    }
  }

  static Future<bool> register(String name, String email, String username,
      String password, bool rightHanded) async {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) async =>
      {
        await FirebaseFirestore.instance.collection("users").doc(
            value.user!.uid).set({
          "name": name,
          "email": email,
          "username": username,
          "rightHanded": rightHanded,
          "joined": DateTime.now(),
          "likes": 0,
        }).catchError((error) =>
        {
          throw error
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

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users")
        .doc(uid).collection("posts")
        .orderBy(
      "timestamp",
      descending: true,
    )
        .get();
    for (var doc in query.docs) {
      if (doc.exists) {
        final data = doc.data() as Map<String,
            dynamic>; // Cast to Map<String, dynamic>
        final text = data['text'];
        final timestamp = data['timestamp'].toDate();
        final imageUrl = data['image'];

        SocialUser? user = await SocialUser.fromFirebase(uid);
        if (user == null) {
          throw Exception("User not found");
        }

        list.add(Post(id: doc.id,
            text: text,
            timestamp: timestamp,
            user: user,
            imageUrl: imageUrl));
      }
    }
    return list;
  }

  static Future<List<SocialUser>> getUsersByUsername(String username) async {
    final query = await FirebaseFirestore.instance.collection("users").where(
        "username", isEqualTo: username).get();
    if (query.docs.isEmpty) {
      return [];
    }

    SocialUser? res = await SocialUser.fromFirebase(query.docs[0].id);
    return [res!];
  }

  static Future<bool> checkIfFollowing(String uid) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    if (currentUser == null) {
      throw Exception("User not found");
    }

    final query = await FirebaseFirestore.instance.collection("users").doc(
        currentUser).collection("following").doc(uid).get();
    return query.exists;
  }

  static Future<void> followUser(String uid) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    if (currentUser == null) {
      throw Exception("User not found");
    }

    if(await checkIfFollowing(uid)) {
      await FirebaseFirestore.instance.collection("users").doc(
          currentUser).collection("following").doc(uid).delete();
      await FirebaseFirestore.instance.collection("users").doc(
          uid).collection("followers").doc(currentUser).delete();
    } else {
      await FirebaseFirestore.instance.collection("users").doc(
          currentUser).collection("following").doc(uid).set({
        "timestamp": DateTime.now(),
      });
      await FirebaseFirestore.instance.collection("users").doc(
          uid).collection("followers").doc(currentUser).set({
        "timestamp": DateTime.now(),
      });
    }
  }

  static Future<int> getFollowersCount(String uid) async {
    final query = await FirebaseFirestore.instance.collection("users").doc(
        uid).collection("followers").get();
    return query.docs.length;
  }

  static Future<int> getFollowingCount(String uid) async {
    final query = await FirebaseFirestore.instance.collection("users").doc(
        uid).collection("following").get();
    return query.docs.length;
  }

  static Future<List<SocialUser>> getFollowers(String uid) async {
    List<SocialUser> list = [];

    final query = await FirebaseFirestore.instance.collection("users").doc(
        uid).collection("followers").get();
    for (var doc in query.docs) {
      if (doc.exists) {
        final data = doc.data() as Map<String,
            dynamic>; // Cast to Map<String, dynamic>
        final timestamp = data['timestamp'].toDate();

        SocialUser? user = await SocialUser.fromFirebase(doc.id);
        if (user == null) {
          throw Exception("User not found");
        }

        list.add(user);
      }
    }
    return list;
  }

  static Future<List<SocialUser>> getFollowing(String uid) async {
    List<SocialUser> list = [];

    final query = await FirebaseFirestore.instance.collection("users").doc(
        uid).collection("following").get();
    for (var doc in query.docs) {
      if (doc.exists) {
        final data = doc.data() as Map<String,
            dynamic>; // Cast to Map<String, dynamic>
        final timestamp = data['timestamp'].toDate();

        SocialUser? user = await SocialUser.fromFirebase(doc.id);
        if (user == null) {
          throw Exception("User not found");
        }

        list.add(user);
      }
    }
    return list;
  }

  static Future<List<Post>> getFeed() async {
    List<Post> list = [];

    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    if (currentUser == null) {
      throw Exception("User not found");
    }

    final query = await FirebaseFirestore.instance.collection("users").doc(
        currentUser).collection("following").get();
    for (var doc in query.docs) {
      if (doc.exists) {
        final data = doc.data() as Map<String,
            dynamic>; // Cast to Map<String, dynamic>
        final timestamp = data['timestamp'].toDate();

        SocialUser? user = await SocialUser.fromFirebase(doc.id);
        if (user == null) {
          throw Exception("User not found");
        }

        final posts = await getPosts(doc.id);
        list.addAll(posts);
      }
    }
    return list;
  }

  static Future<int> getLikesCount(String uid) async {
    final query = await FirebaseFirestore.instance.collection("users").doc(
        uid).get();
    if (query.exists) {
      final data = query.data() as Map<String,
          dynamic>; // Cast to Map<String, dynamic>
      final likes = data['likes'];
      return likes;
    } else {
      return 0;
    }
  }

}
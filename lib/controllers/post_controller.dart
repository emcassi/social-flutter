import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social/types/post.dart';

class PostController {

  static Future<bool> checkIfUserLikes(Post post) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    bool likes = false;

    if (currentUser == null) {
      throw Exception("User not found");
    }

    try {
      final value = await FirebaseFirestore.instance
          .collection("users")
          .doc(post.user.uid)
          .collection("posts")
          .doc(post.id)
          .get();

      if (value.exists) {
        likes = value.data()?['likes'].contains(currentUser);
      }
    } catch (error) {
      print(error);
      likes = false;
    }
    return likes;
  }

  static Future<int> getNumLikes(Post post) async {
    int likes = 0;

    try {
      final value = await FirebaseFirestore.instance
          .collection("users")
          .doc(post.user.uid)
          .collection("posts")
          .doc(post.id)
          .get();

      if (value.exists) {
        likes = value.data()?['likes'].length;
      }
    } catch (error) {
      likes = 0;
    }
    return likes;
  }

  static Future<int> getNumComments(Post post) async {
    int comments = 0;

    try {
      final value = await FirebaseFirestore.instance
          .collection("users")
          .doc(post.user.uid)
          .collection("posts")
          .doc(post.id)
          .collection("comments")
          .get();

      comments = value.docs.length;
    } catch (error) {
      comments = 0;
    }
    return comments;
  }

  static Future<void> likePost(Post post, bool like) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    if(currentUser == null) {
      throw Exception("User not found");
      return;
    }

    // If the user already likes, remove the like
    if(like) {
      await FirebaseFirestore.instance.collection("users").doc(post.user.uid).collection("posts").doc(post.id).update({
        "likes": FieldValue.arrayRemove([currentUser]),
      }).catchError((error) => {
        print(error)
      });
    } else { // Otherwise, like the post
      await FirebaseFirestore.instance.collection("users").doc(post.user.uid).collection("posts").doc(post.id).update({
        "likes": FieldValue.arrayUnion([currentUser]),
      }).catchError((error) => {
        print(error)
      });
    }

  }

  static Future<void> deletePost(Post post) async {
    await FirebaseFirestore.instance.collection("users").doc(post.user.uid).collection("posts").doc(post.id).delete().catchError((error) => {
      print(error)
    });
  }
}
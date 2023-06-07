import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social/types/comment.dart';
import 'package:social/types/post.dart';
import 'package:social/types/user.dart';

class CommentController {
  static Future<void> addComment(Post post, String comment) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(post.user.uid)
        .collection("posts")
        .doc(post.id)
        .collection("comments")
        .add({
      "comment": comment,
      "user": FirebaseAuth.instance.currentUser!.uid,
      "post": post.id,
      "timestamp": DateTime.now(),
    }).catchError((error) {
      print("ERROR: " + error);
    });
  }

  static Future<List<Comment>> getComments(Post post) async {
    final commentsRef = FirebaseFirestore.instance
        .collection("users")
        .doc(post.user.uid)
        .collection("posts")
        .doc(post.id)
        .collection("comments")
        .orderBy("timestamp", descending: true);

    final comments = await commentsRef.get();

    List<Comment> commentList = [];
    for (var comment in comments.docs) {
      final user = await SocialUser.fromFirebase(comment.data()['user']);
      commentList.add(Comment(
        id: comment.id,
        text: comment.data()['comment'],
        author: user!,
        posted: comment.data()['timestamp'].toDate(),
        post: post,
      ));
    }

    return commentList;
  }

  static Future<void> deleteComment(Comment comment) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(comment.post.user.uid)
        .collection("posts")
        .doc(comment.post.id)
        .collection("comments")
        .doc(comment.id)
        .delete()
        .catchError((error) {
      print("ERROR: " + error);
    });
  }

  static Future<void> editComment(Post post, Comment comment, String text) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(post.user.uid)
        .collection("posts")
        .doc(post.id)
        .collection("comments")
        .doc(comment.id)
        .update({
      "comment": text,
    }).catchError((error) {
      print("ERROR: " + error);
    });
  }

  static Future<void> likeComment(Post post, Comment comment, SocialUser user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(post.user.uid)
        .collection("posts")
        .doc(post.id)
        .collection("comments")
        .doc(comment.id)
        .collection("likes")
        .doc(user.uid)
        .set({
      "user": user.uid,
      "timestamp": DateTime.now(),
    }).catchError((error) {
      print("ERROR: " + error);
    });
  }
}

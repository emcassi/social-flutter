import 'package:cloud_firestore/cloud_firestore.dart';
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
      "user": post.user.uid,
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
      ));
    }

    return commentList;
  }
}

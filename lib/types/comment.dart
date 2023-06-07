import 'package:social/types/post.dart';
import 'package:social/types/user.dart';

class Comment {
  final String id;
  final Post post;
  final String text;
  final SocialUser author;
  final DateTime posted;

  const Comment({required this.id, required this.post, required this.text, required this.author, required this.posted});
}
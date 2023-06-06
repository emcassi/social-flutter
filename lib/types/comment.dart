import 'package:social/types/user.dart';

class Comment {
  final String id;
  final String text;
  final SocialUser author;
  final DateTime posted;

  const Comment({required this.id, required this.text, required this.author, required this.posted});
}
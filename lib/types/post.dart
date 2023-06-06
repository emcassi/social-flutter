import 'package:social/types/user.dart';

class Post {
  String id;
  String text;
  String? imageUrl;
  DateTime timestamp;
  SocialUser user;

  Post({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.user,
    this.imageUrl,
  });
}
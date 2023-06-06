import 'package:social/types/user.dart';

class Post {
  String text;
  DateTime timestamp;
  SocialUser user;

  Post({
    required this.text,
    required this.timestamp,
    required this.user,
  });
}
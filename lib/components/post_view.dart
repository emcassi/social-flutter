import 'package:flutter/material.dart';
import 'package:social/types/post.dart';
import 'package:social/types/user.dart';

class PostView extends StatelessWidget {
  final Post post;
  PostView({Key? key, required this.post}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final avi = post.user.aviUrl != null ? NetworkImage(post.user.aviUrl!) : Image.asset("assets/images/no_avatar.png").image;

    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: avi,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("@${post.user.username}", style: const TextStyle(fontSize: 14)),
                ],
              ))
            ],
          ),
            Container(
              padding: const EdgeInsets.only(top: 10),
            child: Text(post.text),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            ],
          ),
          Divider(),
        ],
      )
    );
  }
}

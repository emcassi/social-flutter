import 'package:flutter/material.dart';
import 'package:social/components/comment.dart';
import 'package:social/components/post_view.dart';
import 'package:social/types/comment.dart';
import 'package:social/types/post.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("@${widget.post.user.username})"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostView(post: widget.post),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Add a comment...",
                            border: InputBorder.none,
                          ),
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text("Post"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text("Comments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ListView.builder(itemBuilder: (context, index) {
                    Comment comment = Comment(id: "1234", text: "Tasdpfoijas dfpaoisdaposd fasp odijapos djpoiaj dfasdfasdf asd fasd fasd fasd fasd fasd fasdf asd f", author: "12345", posted: DateTime.now());
                    return CommentView(comment: comment);
                  }, itemCount: 10, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

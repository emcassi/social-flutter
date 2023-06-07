import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/comment.dart';
import 'package:social/components/post_view.dart';
import 'package:social/controllers/comment_controller.dart';
import 'package:social/types/comment.dart';
import 'package:social/types/post.dart';
import 'package:social/types/user.dart';

class PostPage extends StatefulWidget {
  final Post post;
  final focusNode = FocusNode();
  PostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  late Future<List<Comment>> comments;

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentsStream() {
    return FirebaseFirestore.instance.collection('users').doc(widget.post.user.uid).collection("posts").doc(widget.post.id).collection("comments").snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comments = CommentController.getComments(widget.post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("@${widget.post.user.username}'s post"),
      ),
      body: GestureDetector(
        onTap: () {
          widget.focusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostView(post: widget.post, parent: widget),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: "Add a comment...",
                              border: InputBorder.none,
                            ),
                            minLines: 2,
                            maxLines: 5,
                            focusNode: widget.focusNode,
                            onChanged: (val) {
                              setState(() {
                                _formKey.currentState!.validate();
                              });
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter a comment";
                              } else if (val.length > 200) {
                                return "Comment must be less than 200 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(
                                    "${_commentController.text.length}/200",
                                    style: TextStyle(
                                        color:
                                            _commentController.text.length > 200
                                                ? Colors.red
                                                : Colors.grey)),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                CommentController.addComment(
                                        widget.post, _commentController.text)
                                    .then((val) => {
                                          setState(() {
                                            _commentController.clear();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text("Comment posted")));
                                            comments = CommentController.getComments(widget.post);
                                          })
                                        })
                                    .catchError((error) => print(error));
                              }
                            },
                            child: const Text("Post"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text("Comments",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: getCommentsStream(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading...');
                        }

                        // Process the snapshot data here
                        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = documents[index].data() as Map<String, dynamic>;

                            return FutureBuilder<SocialUser?>(
                              future: SocialUser.fromFirebase(data["user"]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return CommentView(comment: Comment(
                                    id: documents[index].id,
                                    author: snapshot.data!,
                                    text: data["comment"],
                                    posted: data["timestamp"].toDate(),
                                    post: widget.post,
                                  ));
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  return const Center(child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ));
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

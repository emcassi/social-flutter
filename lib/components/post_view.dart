import 'package:flutter/material.dart';
import 'package:social/controllers/post_controller.dart';
import 'package:social/pages/post.dart';
import 'package:social/types/post.dart';
import 'package:social/types/user.dart';

class PostView extends StatefulWidget {
  final Post post;
  final PostPage? parent;
  PostView({Key? key, required this.post, this.parent}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool liked = false;
  int numLikes = 0;
  int numComments = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PostController.checkIfUserLikes(widget.post).then((value) {
      setState(() {
        liked = value;
      });
    }).catchError((error) => print(error));

    PostController.getNumLikes(widget.post).then((value) {
      setState(() {
        numLikes = value;
      });
    }).catchError((error) => print(error));

    PostController.getNumComments(widget.post).then((value) {
      setState(() {
        numComments = value;
      });
    }).catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    final avi = widget.post.user.aviUrl != null ? NetworkImage(widget.post.user.aviUrl!) : Image.asset("assets/images/no_avatar.png").image;
    return Container(
        padding: const EdgeInsets.all(10),
        color: Colors.transparent,
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
                          Text(widget.post.user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("@${widget.post.user.username}", style: const TextStyle(fontSize: 14)),
                        ],
                      )),
              const Spacer(),
                  PopupMenuButton(
                    onSelected: (String value) {
                      // handle the user's selection
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuItem<String>>[
                        PopupMenuItem(
                          value: 'Hide',
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.visibility_off),
                              SizedBox(width: 5,),
                              Text('Hide'),
                            ],
                          ),
                          onTap: () {
                          },
                        ),
                        PopupMenuItem(
                          value: 'Delete',
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 5,),
                              Text('Delete'),
                            ],
                          ),
                          onTap: () {
                            PostController.deletePost(widget.post).then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post deleted")));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error deleting post")));
                            });
                          },
                        ),
                      ];
                    },
                  ),
            ],
          ),
            widget.post.imageUrl == null ? Container() : Container(
              padding: const EdgeInsets.only(top: 10),
              child: Center(child: Image.network(widget.post.imageUrl!)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
            child: Text(widget.post.text, style: const TextStyle(fontSize: 18)),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text("$numLikes", style: const TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(width: 5,),
                Text("Likes"),
                const SizedBox(width: 10,),
                Text("$numComments", style: const TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(width: 5,),
                Text("Comments"),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                    IconButton(onPressed: () {
                      PostController.likePost(widget.post, liked).then((value) {
                        setState(() {
                          liked = !liked;
                          if(liked) numLikes++;
                          else numLikes--;
                        });
                      }).catchError((error) => print(error));
                    }, icon: liked ? const Icon(Icons.favorite, color: Colors.pink,) : const Icon(Icons.favorite_border)),
                    widget.parent != null ? Container() : IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              ],
            ),
          ),
          Divider(),
        ],
      )
    );
  }
}

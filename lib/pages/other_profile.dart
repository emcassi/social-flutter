import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social/components/post_view.dart';
import 'package:social/controllers/AuthController.dart';
import 'package:social/controllers/formatter.dart';
import 'package:social/pages/post.dart';
import 'package:social/pages/settings.dart';
import 'package:social/providers/user_provider.dart';
import 'package:social/types/post.dart';
import 'package:social/types/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class OtherProfile extends StatefulWidget {
  SocialUser user;
  OtherProfile({Key? key, required this.user}) : super(key: key);
  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> with RouteAware {
  bool isFollowing = false;
  bool canFollow = true;
  int numLikes = 0;
  int numFollowers = 0;
  int numFollowing = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthController.checkIfFollowing(widget.user.uid).then((value) => {
          setState(() {
            isFollowing = value;
          })
        });
    AuthController.getFollowersCount(widget.user.uid).then((value) => {
          setState(() {
            numFollowers = value;
          })
        });

    AuthController.getFollowingCount(widget.user.uid).then((value) => {
          setState(() {
            numFollowing = value;
          })
        });

    AuthController.getLikesCount(widget.user.uid).then((value) => {
      setState(() {
            numLikes = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("@${widget.user.username}"),
        ),
        body: Consumer<UserProvider>(builder: (context, provider, _) {
          Future<List<Post>> posts = AuthController.getPosts(widget.user.uid);

          return VisibilityDetector(
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction == 1) {
                setState(() {
                  posts = AuthController.getPosts(widget.user.uid);
                });
              }
            },
            key: Key("other-profile"),
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Stack(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 15),
                            child: Column(children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: widget.user.aviUrl == null
                                    ? Image.asset("assets/images/no-avatar.png")
                                        .image
                                    : NetworkImage(widget.user.aviUrl!),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.user.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "@${widget.user.username}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          Formatter.number(numLikes),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          "Likes",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          Formatter.number(numFollowers),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          "Followers",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          Formatter.number(numFollowing),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          "Following",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (canFollow) {
                                      canFollow = false;
                                      await AuthController.followUser(
                                          widget.user.uid);
                                      setState(() {
                                        isFollowing = !isFollowing;
                                        canFollow = true;

                                        if(isFollowing){
                                          numFollowers++;
                                        }else{
                                          numFollowers--;
                                        }
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: isFollowing
                                          ? Colors.grey
                                          : Colors.blue),
                                  child: Text(
                                    "Follow${isFollowing ? "ing" : ""}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Text(widget.user.bio ?? ""),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  widget.user.website != null
                                      ? Row(
                                          children: [
                                            const Icon(Icons.link),
                                            TextButton(
                                              child: Text(widget.user.website!),
                                              onPressed: () async {
                                                // Open website
                                                try {
                                                  final uri = Uri.parse(
                                                      widget.user.website!);
                                                  if (!await launchUrl(uri,
                                                      mode: LaunchMode
                                                          .externalApplication)) {
                                                    throw Exception(
                                                        'Could not launch $uri');
                                                  }
                                                } catch (e) {
                                                  // Show error in an alert
                                                  final alert = AlertDialog(
                                                    title: const Text("Error"),
                                                    content: Text(e.toString()),
                                                  );
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          alert);
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  Row(
                                    children: [
                                      const Icon(Icons.cake),
                                      Text(DateFormat('MMMM d, yyyy')
                                          .format(widget.user.joined)),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                            ])),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Report"),
                                    content: const Text(
                                        "Are you sure you want to report this user?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          // report user
                                          Navigator.pop(
                                              context); // Close the AlertDialog
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the AlertDialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.flag),
                          ),
                        )
                      ],
                    )),
                FutureBuilder(
                    future: posts,
                    builder: (c, snapshot) {
                      if (snapshot.hasData) {
                        final psts = snapshot.data as List<Post>;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: psts.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostPage(
                                                post: psts[index],
                                              )));
                                },
                                child: PostView(
                                  post: psts[index],
                                ));
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ),
          );
        }));
  }
}

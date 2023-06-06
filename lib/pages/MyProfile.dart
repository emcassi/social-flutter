import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social/components/post_view.dart';
import 'package:social/controllers/AuthController.dart';
import 'package:social/controllers/route_observer.dart';
import 'package:social/pages/post.dart';
import 'package:social/pages/settings.dart';
import 'package:social/providers/user_provider.dart';
import 'package:social/types/post.dart';
import 'package:social/types/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with RouteAware {
  final String bio = """
  Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
  """;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, _) {
      final SocialUser? user = provider.user;
      Future<List<Post>> posts = AuthController.getPosts(user!.uid);

      return VisibilityDetector(
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1) {
            setState(() {
              posts = AuthController.getPosts(user.uid);
            });
          }
        },
        key: Key("my-profile"),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(
                  children: [
                    Container(
                        padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 15),
                        child: Column(children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user?.aviUrl ??
                                "https://th.bing.com/th/id/OIP.UujSBl4u7QBJFs8bfiYFfwHaHa?pid=ImgDet&rs=1"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            user?.name ?? "",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "@${user?.username}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "1.5K",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
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
                                      "2.5K",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
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
                                      "1.5K",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Following",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(user?.bio ?? bio),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              user?.website != null
                                  ? Row(
                                children: [
                                  Icon(Icons.link),
                                  TextButton(
                                    child: Text(user!.website!),
                                    onPressed: () async {
                                      // Open website
                                      try {
                                        final uri =
                                        Uri.parse(user.website!);
                                        if (!await launchUrl(uri,
                                            mode: LaunchMode
                                                .externalApplication)) {
                                          throw Exception(
                                              'Could not launch $uri');
                                        }
                                      } catch (e) {
                                        // Show error in an alert
                                        final alert = AlertDialog(
                                          title: Text("Error"),
                                          content: Text(e.toString()),
                                        );
                                        showDialog(
                                            context: context,
                                            builder: (context) => alert);
                                      }
                                    },
                                  ),
                                ],
                              )
                                  : Container(),
                              Row(
                                children: [
                                  Icon(Icons.cake),
                                  Text(DateFormat('MMMM d, yyyy')
                                      .format(user!.joined)),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                        ])),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings(user: user!)),
                          );
                        },
                        icon: Icon(Icons.settings),
                      ),
                    )
                  ],
                )),
            FutureBuilder(
                future: posts,
                builder: (c, snapshot) {
                  if(snapshot.hasData) {
                    final psts = snapshot.data as List<Post>;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: psts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print("SDFPOIJSDF");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(post: psts[index],)));
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
                }
            ),
          ],
        ),
      );
    });
  }
}

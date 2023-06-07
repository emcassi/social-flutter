import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social/components/post_view.dart';
import 'package:social/controllers/AuthController.dart';
import 'package:social/controllers/formatter.dart';
import 'package:social/pages/edit_profile.dart';
import 'package:social/pages/post.dart';
import 'package:social/pages/see_followers.dart';
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

  String uid = FirebaseAuth.instance.currentUser!.uid;

  int numFollowers = 0;
  int numFollowing = 0;
  int numLikes = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthController.getFollowersCount(uid).then((value) => {
        numFollowers = value
    });

    AuthController.getFollowingCount(uid).then((value) => {
        numFollowing = value
    });

    AuthController.getLikesCount(uid).then((value) => {
        numLikes = value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, _) {
      final SocialUser? user = provider.user;
      if(user == null) {
        return const Center(child: CircularProgressIndicator());
      }
      Future<List<Post>> posts = AuthController.getPosts(user.uid);

      return VisibilityDetector(
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1) {
            setState(() {
              posts = AuthController.getPosts(user.uid);
            });
          }
        },
        key: const Key("my-profile"),
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
                            backgroundImage: user.aviUrl == null ? Image.asset("assets/images/no-avatar.png").image : NetworkImage(user.aviUrl!),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            user.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "@${user.username}",
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
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SeeFollowers(user: provider.user!, type: "followers")));
                                  },
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
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SeeFollowers(user: provider.user!, type: "following")));
                                  },
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
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ElevatedButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(user: user)));
                            }, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600]), child: const Text("Edit Profile")),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(user.bio ?? "", textAlign: TextAlign.center, style: const TextStyle(fontSize: 14),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              user.website != null
                                  ? Row(
                                children: [
                                  const Icon(Icons.link),
                                  TextButton(
                                    child: Text(user.website!),
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
                                          title: const Text("Error"),
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
                                  const Icon(Icons.cake),
                                  Text(DateFormat('MMMM d, yyyy')
                                      .format(user.joined)),
                                ],
                              ),
                            ],
                          ),
                        ])),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings(user: user)),
                          );
                        },
                        icon: const Icon(Icons.settings),
                      ),
                    )
                  ],
                )),
            const Divider(height: 20, thickness: 1,),
            FutureBuilder(
                future: posts,
                builder: (c, snapshot) {
                  if(snapshot.hasData) {
                    final psts = snapshot.data as List<Post>;

                    if(psts.isEmpty) return const Center(child: Text("No posts yet"),);

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: psts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
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
                    return const Center(child: CircularProgressIndicator());
                  }
                }
            ),
          ],
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:social/controllers/AuthController.dart';
import 'package:social/pages/other_profile.dart';
import 'package:social/types/user.dart';

class SeeFollowers extends StatefulWidget {
  final SocialUser user;
  final String type;

  const SeeFollowers({Key? key, required this.user, required this.type}) : super(key: key);

  @override
  State<SeeFollowers> createState() => _SeeFollowersState();
}

class _SeeFollowersState extends State<SeeFollowers> {
  List<SocialUser> _users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.type == "followers") {
      AuthController.getFollowers(widget.user.uid).then((value) =>
          setState(() {
            _users = value;
          })
      );
    } else {
      AuthController.getFollowing(widget.user.uid).then((value) => {
        setState(() {
          _users = value;
        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type == "followers" ? "Followers" : "Following"),),
      body: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            print(_users.length);
        if(_users.length == 0) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(user: _users[index])));
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_users[index].aviUrl ?? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"),
              ),
              title: Text(_users[index].username),
              subtitle: Text(_users[index].name),
            ),
          );
        }
      }),
    );
  }
}

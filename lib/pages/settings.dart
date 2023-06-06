import 'package:flutter/material.dart';
import 'package:social/controllers/AuthController.dart';
import 'package:social/pages/edit_profile.dart';
import 'package:social/types/user.dart';

class Settings extends StatelessWidget {
  final SocialUser user;

  const Settings({Key? key, required this.user}) : super(key: key);

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {

    // make a list to go to Edit Profile, Account, Notifications, Privacy, Security, Help, About, Logout
    // make a list of icons to go with each of the above
    // make a list of routes to go with each of the above

    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: ListView(
      children: [
                  ListTile(
          leading: const Icon(Icons.edit),
          title: Text('Edit Profile'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile(user: user,)),
          );}
        ),
        ListTile(
          leading: const Icon(Icons.account_box),
          title: const Text('Account'),
          onTap: () {
            // Navigator.pushNamed(context, '/account');
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {
            // Navigator.pushNamed(context, '/notifications');
          },
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Privacy'),
          onTap: () {
            // Navigator.pushNamed(context, '/privacy');
          },
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Security'),
          onTap: () {
            // Navigator.pushNamed(context, '/security');
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help'),
          onTap: () {
            // Navigator.pushNamed(context, '/help');
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            // Navigator.pushNamed(context, '/about');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () async {
            await AuthController.logout();
            Navigator.pushNamedAndRemoveUntil(context, '/noauth', (route) => false);
          },
        ),
      ],
    ));
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/controllers/AuthController.dart';
import 'package:social/pages/other_profile.dart';
import 'package:social/types/user.dart';

class Browse extends StatefulWidget {

  Browse({Key? key}) : super(key: key);

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  final SearchController searchController = SearchController();
  final FocusNode _focusNode = FocusNode();

  bool _searching = false;
  List<SocialUser> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse"),
        leading: _focusNode.hasFocus ? IconButton(
          onPressed: () {
            _focusNode.unfocus();
            setState(() {
              _searching = false;
            });
          },
          icon: const Icon(Icons.clear),
        ) : null,
        actions: [
          IconButton(
            onPressed: () {
              _focusNode.requestFocus();
              setState(() {
                _searching = true;
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(
              controller: searchController,
              hintText: "Search for users...",
              onTap: () {
                setState(() {
                  _searching = true;
                });
              },
              onChanged: (val) async {
                  AuthController.getUsersByUsername(val).then((value) {
                    setState(() {
                      _searchResults = value;
                    });
                  });
              },
              focusNode: _focusNode,
            ),
            _focusNode.hasFocus ? SizedBox(
              height: MediaQuery.of(context).size.height - 192,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  SocialUser? user = _searchResults[index];
                return SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(user: user)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.aviUrl != null ? Image.network(user.aviUrl!).image : const AssetImage("assets/images/no-avatar.png"),
                        ),
                        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("@${user.username}"),
                        trailing: user.uid == FirebaseAuth.instance.currentUser!.uid ? const Text("Me") : IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                      ),
                    ),
                  )
                );
              }, itemCount: _searchResults.length,),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}

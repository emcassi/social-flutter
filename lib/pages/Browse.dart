import 'package:flutter/material.dart';

class Browse extends StatefulWidget {

  Browse({Key? key}) : super(key: key);

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  final SearchController searchController = SearchController();
  final FocusNode _focusNode = FocusNode();

  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse"),
        leading: _focusNode.hasFocus ? IconButton(
          onPressed: () {
            searchController.text = "";
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
              focusNode: _focusNode,
            ),
            _focusNode.hasFocus ? SizedBox(
              height: MediaQuery.of(context).size.height - 192,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                return SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/no-avatar.png"),
                      ),
                      title: Text("Alexa"),
                      subtitle: Text("@alexa"),
                      trailing: Icon(Icons.add),
                    ),
                  ),
                );
              }, itemCount: 10,),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}

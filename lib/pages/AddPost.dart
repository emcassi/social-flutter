import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Post")),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
        child: Form(
          key: formKey,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("New Post"),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 10,
                  onChanged: (e) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Post cannot be empty";
                    }
                    if (textEditingController.text.length > 280) {
                      return "Post cannot be longer than 280 characters";
                    }
                    return null;
                  },
                ),
                Text(
                  "${textEditingController.text.length}/280",
                  style: TextStyle(
                      color: textEditingController.text.length > 280
                          ? Colors.red
                          : Colors.grey),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("posts").add
                        ({
                          "text": textEditingController.text,
                          "timestamp": DateTime.now(),
                        }).then((value) {
                        Navigator.pop(context, textEditingController.text);
                      }).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error: $e"),
                        ));
                      });
                    }
                  },
                  child: Text("Post"),
                ),
              ],
            ),
          ],
        )),
      )),
    );
  }
}

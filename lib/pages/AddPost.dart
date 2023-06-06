import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Post")),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image == null
                    ? Container()
                    : Container(
                        width: 300,
                        height: 300,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Stack(
                          children: [
                            Center(child: Image.file(File(image!), fit: BoxFit.cover)),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  )),
                            ),
                          ],
                        ),
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 60,
                      child: IconButton(
                          onPressed: () {
                            final modal = AlertDialog(
                              title: Text("Add Image"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.camera);
                                      if (pickedFile != null) {
                                        setState(() {
                                          image = pickedFile.path;
                                        });
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Camera")),
                                TextButton(
                                    onPressed: () async {
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        setState(() {
                                          image = pickedFile.path;
                                        });
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Gallery")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            );
                            showDialog(
                                context: context, builder: (context) => modal);
                          },
                          icon: const Column(
                            children: [
                              Icon(Icons.add_a_photo),
                              Text("Add Media"),
                            ],
                          )),
                    ),
                    const Text("OR",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 100,
                      height: 60,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Column(
                            children: [
                              Icon(Icons.gif_rounded),
                              Text("Add GIF"),
                            ],
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (image == null) {
                            FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("posts").add({
                              "text": textEditingController.text,
                              "timestamp": DateTime.now(),
                            }).then((value) {
                              Navigator.pop(
                                  context, textEditingController.text);
                            }).catchError((e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Error: $e"),
                              ));
                            });
                          } else {
                            Reference storageReference = FirebaseStorage
                                .instance
                                .ref()
                                .child('images/${DateTime.now().toString()}');

                            UploadTask uploadTask =
                            storageReference.putFile(File(image!));
                            uploadTask.whenComplete(() async {
                              String url =
                              await storageReference.getDownloadURL();

                              FirebaseFirestore.instance.collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("posts").add({
                                "text": textEditingController.text,
                                "image": url,
                                "timestamp": DateTime.now(),
                              })
                                  .then((value) {
                                Navigator.pop(context,
                                    textEditingController.text);
                              }).catchError((e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Error: $e"),
                                ));
                              });
                            });
                          }
                        }
                      },
                      child: const Text("Post"),
                    ),
                  ],
                ),
              ],
            )),
      )),
    );
  }
}

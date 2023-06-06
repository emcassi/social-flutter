import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social/components/ClearableTextField.dart';
import 'package:social/components/CountingTextField.dart';
import 'package:social/providers/user_provider.dart';
import 'package:social/types/user.dart';

class EditProfile extends StatefulWidget {
  final SocialUser user;

  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final websiteController = TextEditingController();

  late Image avi;
  late File aviFile;

  final defaultImage =
      "https://th.bing.com/th/id/OIP.UujSBl4u7QBJFs8bfiYFfwHaHa?pid=ImgDet&rs=1";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.user.name;
    bioController.text = widget.user.bio ?? "";
    websiteController.text = widget.user.website ?? "";

    if (widget.user.aviUrl != null) {
      avi = Image.network(widget.user.aviUrl!);
      aviFile = File(widget.user.aviUrl!);
    } else {
      avi = Image.network(defaultImage);
      aviFile = File(defaultImage);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Use the pickedImage file
      setState(() {
        avi = Image.file(File(pickedImage.path));
        aviFile = File(pickedImage.path);
      });
      // Process or display the image as desired
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, _) {
      final SocialUser? user = provider.user;
      return Scaffold(
          appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: CircleAvatar(
                      backgroundImage: avi.image,
                      radius: 50,
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text("Name"),
                      suffix: nameController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                nameController.text = "";
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            )
                          : null,
                    ),
                  ),
                  CountingTextField(
                    controller: bioController,
                    label: "Bio",
                    maxLines: 10,
                    maxLength: 160,
                    validator: (value) {
                      if (value != null && value.length > 160) {
                        return 'Please shorten your bio';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: websiteController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (!Uri.parse(value).isAbsolute) {
                        return 'Please enter a valid website';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text("Website"),
                      suffix: websiteController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                websiteController.text = "";
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saving Data')),
                          );

                          if (aviFile == File(defaultImage) ||
                              aviFile == File(widget.user.aviUrl ?? "")) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.user.uid)
                                .update({
                              "name": nameController.text,
                              "bio": bioController.text,
                              "website": websiteController.text,
                            }).then((value) async {
                              await provider.fetchUser();
                              Navigator.pop(context);
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            });
                          } else {
                            Reference storageReference = FirebaseStorage
                                .instance
                                .ref()
                                .child('images/${DateTime.now().toString()}');

                            UploadTask uploadTask =
                                storageReference.putFile(aviFile);
                            uploadTask.whenComplete(() async {
                              String url =
                                  await storageReference.getDownloadURL();
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.user.uid)
                                  .update({
                                "name": nameController.text,
                                "bio": bioController.text,
                                "website": websiteController.text,
                                "aviUrl": url,
                              }).then((value) async {
                                await provider.fetchUser();
                                Navigator.pop(context);
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())),
                                );
                              });
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            });
                          }
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

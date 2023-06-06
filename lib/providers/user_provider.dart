import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:social/types/user.dart';

class UserProvider extends ChangeNotifier {
  SocialUser? _user;

  SocialUser? get user => _user;

  Future<void> fetchUser() async {
    User? fbUser = FirebaseAuth.instance.currentUser;
    if(fbUser == null) {
      _user = null;
    } else {
      _user = await SocialUser.fromFirebase(fbUser.uid);
    }
    notifyListeners();
  }
}
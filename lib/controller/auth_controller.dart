import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winners_world_app/dashboard.dart';
import '/screens/login_screen.dart';

class AuthController extends GetxController {
  //create a global instance for calling anywhere in app
  static AuthController instance = Get.find();
  //user for our getx
  late Rx<User?> _user;
  //firbase auth instance for user
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    //provides current user state to our getx
    _user = Rx<User?>(_auth.currentUser);
    //binding our getx to track any changes and notified
    _user.bindStream(_auth.userChanges());
    //bound our user to listener for some activity on screen and navigate
    ever(_user, _initialScreen);
  }

  //navigating initial screen based on current user

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => Dashboard(
            useremail: user.email!,
          ));
    }
  }

  //helper functions for authication
  void register(String email, password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar(
        'About User',
        'User message',
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Account creation failed',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void login(String email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        "About Login",
        'Login message',
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Login failed',
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void logout() async {
    await _auth.signOut();
  }
}

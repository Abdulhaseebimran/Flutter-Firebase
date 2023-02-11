import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasee/ui/auth/login.dart';
import 'package:firebasee/ui/firestore/firestore_list_screen.dart';
import 'package:firebasee/ui/post/post_screen.dart';
import 'package:firebasee/ui/upload_image.dart';
import 'package:flutter/material.dart';

class SplashService {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UploadImage()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Login()));
      });
    }
  }
}

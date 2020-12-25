import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import '../components/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx,
      [String imagePath]) async {
    AuthResult authResult;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String downloadUrl = '';
        if (imagePath.isNotEmpty && imagePath != null) {
          //TODO: upload image to firebase storage
          final ref = FirebaseStorage.instance
              .ref()
              .child('users')
              .child('profile_pics')
              .child(authResult.user.uid + '.jpg');
          final uploadTask = ref.putFile(File(imagePath));
          await uploadTask.onComplete;
          downloadUrl = (await ref.getDownloadURL()) ?? '';
        }

        ///Cloud firestore parameters for a user
        ///@param `username`
        ///@param `email`
        ///@param `profile_image_path` which is an empty string if user didn't select
        ///an image to upload
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'profile_image_path': downloadUrl,
        });
      }
      isLoading = false;
    } on PlatformException catch (err) {
      var message = "An error occurred, please check your credentials";
      if (err.message != null) {
        message = err.message;
      }
      setState(() {
        isLoading = false;
      });
      Scaffold.of(ctx).showSnackBar(new SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, isLoading));
  }
}

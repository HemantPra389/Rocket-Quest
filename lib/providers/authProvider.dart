import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'users_data.dart';

class AuthProvider with ChangeNotifier {
  Map<String, String> userData_signup = {
    'email': '',
    "username": '',
    'password': ''
  };
  Map<String, String> userData_login = {'email': '', 'password': ''};
  late String _imageUrl;

  Future<void> createUser(Map<String, String> usercredentials,
      BuildContext context, File image) async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: usercredentials['email']!,
              password: usercredentials['password']!);
      var userdata = Provider.of<UsersData>(context, listen: false);
      await userdata.setUserData({
        'username': usercredentials['username'],
        'email': usercredentials['email'],
      }, imageUrl).then((value) => print('Successfully Saved!'));
      final ref = await FirebaseStorage.instance
          .ref()
          .child('user-images')
          .child(authResult.user!.uid + '.jpeg');
      await ref.putFile(image).whenComplete(() => null);
      _imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'username': usercredentials['username'],
        'email': usercredentials['email'],
        'image_url': _imageUrl
      });
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message!),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      print(error);
    }
  }

  String get imageUrl {
    return _imageUrl;
  }

  Future<void> createUser_login(
      Map<String, String> usercredentials, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usercredentials['email']!,
          password: usercredentials['password']!);
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message!),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      print(error);
    }
  }

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user {
    return _user!;
  }

  Future<void> login_google(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn().catchError((error) {
        print(error);
      });

      if (googleUser == null) {
        return;
      }
      _user = googleUser;
      final googleauth = await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleauth.accessToken, idToken: googleauth.idToken);
      await FirebaseAuth.instance
          .signInWithCredential(credentials)
          .then((value) async {
        var userdata = Provider.of<UsersData>(context, listen: false);
        _imageUrl = googleUser.photoUrl!;
        await userdata.setUserData({
          'username': googleUser.displayName,
          'email': googleUser.email,
        }, imageUrl).then((value) => print('Successfully Saved!'));
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(googleUser.id)
          .set({
        'username': googleUser.displayName,
        'email': googleUser.email,
        'image_url': _imageUrl
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Submitted'),
        backgroundColor: Colors.green,
      ));
      notifyListeners();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }
}

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

/*
* ChangeNotifier class uses with keyword which helps the user to bring listenable changes.This usually used for stateManagement.
* Maximum Function in these type of classes are Future Functions which returns future and need some time to be executed. In Future fuction we use async keyword after () async 
*We can use several way of storing changing and executing of data. 
*/
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
      //* To create a firebase account we just have to remember the syntax which returns us the future for which we write await keyword before the syntax
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: usercredentials['email']!,
              password: usercredentials['password']!);
      var userdata = Provider.of<UsersData>(context, listen: false);
      await userdata.setUserData({
        'username': usercredentials['username'],
        'email': usercredentials['email'],
      }, imageUrl).then((value) => print('Successfully Saved!'));
      //*In FirebaseStorage we store data in bucket first of all we need bucket or reference where the file is to be stored and just create any numbe of child
      final ref = await FirebaseStorage.instance
          .ref()
          .child('user-images')
          .child(authResult.user!.uid + '.jpeg');
      //*putfile is the function just to put the file in the location create above.
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
      //* According to our needs we can create errors just by using on keyword
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

  //* For google sign in just create a instance of googleSignin the create a user
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user {
    return _user!;
  }

  Future<void> login_google(BuildContext context) async {
    try {
      //*below syntax will create a pop up which contains some id to be used for sign in
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn().catchError((error) {
        print(error);
      });

      if (googleUser == null) {
        return;
      }
      _user = googleUser; //*initializing user
      final googleauth = await googleUser.authentication; //*creating auth
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleauth.accessToken,
          idToken: googleauth.idToken); //*checking user
      await FirebaseAuth.instance //*signing in the email
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

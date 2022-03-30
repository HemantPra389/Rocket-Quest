import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

var data;

class UsersData with ChangeNotifier {
  String? _username;
  String? _email;
  String? _imageUrl;

  Future<void> setUserData(Map userCredentials, String imgUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('user_data',
        [userCredentials['username'], userCredentials['email'], imgUrl]);

    print(data);
    notifyListeners();
  }

  String get username {
    return _username!;
  }

  String get email {
    return _email!;
  }

  get imageUrl {
    if (_imageUrl == null) {
      return null;
    } else {
      return _imageUrl!;
    }
  }

  Future<List> showData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data = prefs.getStringList('user_data');
    _username = data[0];
    _email = data[1];
    _imageUrl = data[2];
    return data;
  }
}

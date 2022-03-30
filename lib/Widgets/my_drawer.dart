import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/users_data.dart';
import 'package:quiz_app/screens/auth_screen.dart';
import 'package:quiz_app/screens/setting_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  final String imageurl;
  bool isImageLoaded = false;
  MyDrawer(this.imageurl);
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UsersData>(context);

    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 90, left: 15, right: 15),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 0),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(imageurl),
              ),
              title: Text(
                user.username,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              subtitle: Text(user.email,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            drawerTile('LeaderBoard', () {}),
            drawerTile('Statstic', () {}),
            Divider(
              thickness: 1,
              color: Colors.grey.shade400,
            ),
            drawerTile('Invite People', () {
              Share.share(
                  'My total score is more than 500 Join me on Quiz App and score to earn.');
            }),
            drawerTile('Settings', () {
              Navigator.of(context).popAndPushNamed(SettingScreen.routename);
            }),
            Divider(
              thickness: 1,
              color: Colors.grey.shade400,
            ),
            drawerTile('About Us', () async {
              const url = "https://github.com/HemantPra389";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw "Could not launch $url";
              }
            }),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: TextButton.icon(
                  label: Text(
                    'Log Out ',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    FirebaseAuth.instance
                        .signOut()
                        .then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthScreen(),
                            ),
                            (route) => false));
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 30,
                    color: Colors.grey,
                  ),
                  // 'Log Out ',
                  // style: TextStyle(
                  //     color: Colors.grey.shade800,
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell drawerTile(String title, Function drawer_selection) {
    return InkWell(
      onTap: () {
        drawer_selection();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: Colors.grey.shade800),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 30,
              color: Colors.grey.shade800,
            ),
          ],
        ),
      ),
    );
  }
}

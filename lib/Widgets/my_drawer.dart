import 'package:flutter/material.dart';
import 'package:quiz_app/screens/setting_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 90, left: 15, right: 15),
        child: Column(
          children: [
            const ListTile(
              contentPadding: EdgeInsets.only(left: 0),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile_photo.jpeg'),
                radius: 25,
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                'Hemant Prajapati',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              subtitle: Text('hemantpra389@gmail.com',
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
                child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned(
                  child: Text(
                    'Log Out ',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  left: 0,
                  bottom: 30,
                )
              ],
            ))
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

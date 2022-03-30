import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Widgets/myAppBar.dart';
import 'package:quiz_app/providers/questions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  static const routename = 'setting-screen.dart';

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String currentLevel = 'easy';

  @override
  Widget build(BuildContext context) {
    var question_script = Provider.of<Questions>(context, listen: false);

    return Scaffold(
      appBar: MyAppBar('Settings', () {
        Navigator.pop(context);
      }),
      body: Container(
        padding: EdgeInsets.only(top: 30, right: 10, left: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Text(
                'Choose Your Difficulty Level-',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                levelSelector('assets/images/easy.png', "Easy"),
                levelSelector('assets/images/medium.png', "Medium"),
                levelSelector('assets/images/hard.png', "Hard"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool level_boolean(String level) {
    if (level.toLowerCase() == currentLevel) {
      return true;
    }
    return false;
  }

  Column levelSelector(String imagePath, String level) {
    var question_script = Provider.of<Questions>(context);
    return Column(
      children: [
        Container(
          height: 80,
          width: 100,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset(
              imagePath,
            ),
            Positioned(
              right: -5,
              bottom: -5,
              child: Align(
                //It helps to align the widget without any stack required it can be use anywhere in the column,row, list etc
                alignment: Alignment.bottomRight,
                child: Transform.scale(
                  //It will help to transform and to scale the checkbox
                  scale: 1.4,
                  child: FutureBuilder(
                    future: question_script.recieveData().then((value) {
                      currentLevel = question_script.questions_level.toString();
                    }),
                    builder: (context, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? CircularProgressIndicator()
                        : Checkbox(
                            value: level_boolean(level),
                            shape: CircleBorder(),
                            onChanged: (value) {
                              setState(() {
                                currentLevel = level.toLowerCase();

                                question_script.storeLevel(level.toLowerCase());
                              });
                            },
                          ),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            level,
            style: TextStyle(
                fontSize: 25,
                fontFamily: 'Gilroy',
                color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
    //
  }
}

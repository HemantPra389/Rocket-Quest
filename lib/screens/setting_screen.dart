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
  String currentLevel = "easy";
  bool normal_select = false;
  bool intermediate_select = false;
  bool hard_select = false;

  @override
  Widget build(BuildContext context) {
    var question_script = Provider.of<Questions>(context, listen: false);
    question_script.recieveData();
    currentLevel = question_script.questions_level;
    if (currentLevel == "easy") {
      normal_select = true;
      intermediate_select = false;
      hard_select = false;
    } else if (currentLevel == "medium") {
      normal_select = false;
      intermediate_select = true;
      hard_select = false;
    } else if (currentLevel == "hard") {
      normal_select = false;
      intermediate_select = false;
      hard_select = true;
    }

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
                levelSelector('assets/images/easy.png', "Easy", normal_select),
                levelSelector(
                    'assets/images/medium.png', "Medium", intermediate_select),
                levelSelector('assets/images/hard.png', "Hard", hard_select),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                question_script.storeLevel(currentLevel);
                print(currentLevel);
              },
              icon: Icon(Icons.save),
              label: Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  Column levelSelector(String imagePath, String level, bool level_value) {
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
                  child: Checkbox(
                    value: level_value,
                    shape: CircleBorder(),
                    onChanged: (value) {
                      setState(() {
                        if (level == "Easy") {
                          normal_select = true;
                          intermediate_select = false;
                          hard_select = false;
                          currentLevel = 'easy';
                        } else if (level == "Medium") {
                          normal_select = false;
                          intermediate_select = true;
                          hard_select = false;
                          currentLevel = 'medium';
                        } else if (level == "Hard") {
                          normal_select = false;
                          intermediate_select = false;
                          hard_select = true;
                          currentLevel = 'hard';
                        }
                      });
                    },
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

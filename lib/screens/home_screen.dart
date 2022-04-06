import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Widgets/my_drawer.dart';
import 'package:quiz_app/providers/authProvider.dart';
import 'package:quiz_app/providers/questions.dart';
import 'package:quiz_app/providers/users_data.dart';
import 'package:quiz_app/screens/daily_quesion_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routename = '/homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double slidervalue = 1;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  InkWell homeSelectionBtn(
      String title, Function myfun, Color color, Color fontcolor) {
    return InkWell(
      onTap: () {
        myfun();
      },
      child: SizedBox(
        height: 60,
        width: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/_box.png',
              width:
                  double.infinity, //It helps to achieve the full stretched box.
              fit: BoxFit.fill,
              color: color,
            ),
            Text(
              title,
              style: TextStyle(
                  color: fontcolor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var question_script = Provider.of<Questions>(context, listen: false);
    setState(() {
      question_script.recieveData();
    });

    var user = Provider.of<UsersData>(context);

    final _random = Random();
    int next(int min, int max) => min + _random.nextInt(max - min);

    return FutureBuilder(
      future: user.showData(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              key: _key,
              drawer: MyDrawer(user.imageUrl),
              appBar: PreferredSize(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              _key.currentState!.openDrawer();
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20)),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.imageUrl),
                              radius: 20,
                              backgroundColor: Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                preferredSize: const Size.fromHeight(100),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/home_screen.png',
                      width: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Q',
                            style: TextStyle(
                              fontSize: 58,
                              fontFamily: 'Gilroy',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'uiz App',
                            style: TextStyle(
                              fontSize: 50,
                              fontFamily: 'Gilroy',
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 210,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                homeSelectionBtn('Play Quiz', () async {
                                  question_script.category_daily = next(9, 32);

                                  await question_script.fetchQuestion().then(
                                      (value) => question_script.request_code ==
                                              0
                                          ? Navigator.of(context)
                                              .pushNamed(QuizScreen.routename)
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'No Question in this list right now.'))));
                                }, Theme.of(context).primaryColor,
                                    Colors.grey.shade200),
                                homeSelectionBtn('Daily Quiz', () {
                                  Navigator.of(context)
                                      .pushNamed(DailyQuestionScreen.routename);
                                },
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.7),
                                    Colors.grey.shade200),
                                homeSelectionBtn('Quit', () {
                                  SystemNavigator
                                      .pop(); //helps to pop out of running application
                                },
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.4),
                                    Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
    );
  }
}

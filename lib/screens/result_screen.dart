import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/users_data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quiz_app/Widgets/myAppBar.dart';
import 'package:quiz_app/providers/questions.dart';
import 'package:quiz_app/screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  static const routename = '/result-screen';

  @override
  Widget build(BuildContext context) {
    var resultData = Provider.of<Questions>(context);
    final received_result = ModalRoute.of(context)!.settings.arguments as Map;
    int correct_answer = received_result['correct'];
    Duration duration = received_result['duration'];
    var user = Provider.of<UsersData>(context);
    Future<void> uploadResult() async {
      await FirebaseFirestore.instance.collection('user-result').add({
        'image_url': user.imageUrl ?? '',
        'username': user.username,
        'result_score': correct_answer,
        'duration': duration.inSeconds.toString()
      });
    }

    uploadResult();

    return Scaffold(
        appBar: MyAppBar("Quiz Result", () {}),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/congratulation.png')),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 90),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.grey.shade600,
                        child:  CircleAvatar(
                          backgroundImage:
                              NetworkImage(user.imageUrl!),
                          radius: 46,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    resultText(5, "Hemant Prajapati", 18, FontWeight.w300,
                        Colors.grey.shade600),
                    resultText(10, "Congratulations", 28, FontWeight.w300,
                        Colors.black.withOpacity(.8)),
                    resultText(5, "Your Score :", 18, FontWeight.w300,
                        Colors.grey.shade600),
                    Image.asset(
                      'assets/images/badge_.png',
                      width: 80,
                    ),
                    resultText(30, "$correct_answer/10", 30, FontWeight.w600,
                        Colors.grey.shade600),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: LinearPercentIndicator(
                        width: 350,
                        percent: correct_answer / 10,
                        alignment: MainAxisAlignment.center,
                        barRadius: const Radius.circular(20),
                        progressColor: Colors.pink.shade300,
                        lineHeight: 15,
                      ),
                    ),
                    resultText(30, duration.inSeconds.toString() + ' sec', 30,
                        FontWeight.w600, Colors.grey.shade600),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            resultSelectionBtn("Close", () {
                              Navigator.of(context)
                                  .popAndPushNamed(HomeScreen.routename);
                            }),
                            resultSelectionBtn("Share", () {
                              Share.share(
                                'Hemant Prajapati scored $resultData on QuizApp ',
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Container resultText(double topMargin, String title, double fontsize,
      FontWeight fontweight, Color color) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        title,
        style: TextStyle(
            fontSize: fontsize,
            fontFamily: 'Gilroy',
            fontWeight: fontweight,
            color: color),
      ),
    );
  }

  InkWell resultSelectionBtn(String title, Function myfun) {
    return InkWell(
      onTap: () {
        myfun();
      },
      child: SizedBox(
        height: 70,
        width: 170,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/box.png',
              fit: BoxFit.fill,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu'),
            )
          ],
        ),
      ),
    );
  }
}

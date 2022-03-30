import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Widgets/myAppBar.dart';

import 'package:quiz_app/providers/questions.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

class DailyQuestionScreen extends StatelessWidget {
  static const routename = '/daily-question-screen';

  List<String> category = [
    "General Knowledge",
    "Books",
    "Film",
    "Music",
    "Musicals & Theatres",
    "Television",
    "Video Games",
    "Board Games",
    "Science & Nature",
    "Computers",
    "Mathematics",
    "Mythology",
    "Sports",
    "Geography",
    "History",
    "Politics",
    "Art",
    "Celebrities",
    "Animals",
    "Vehicles",
    "Comics",
    "Gadgets",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("Daily Quiz", () {
        Navigator.pop(context);
      }),
      body: Container(
        padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                var question_script =
                    Provider.of<Questions>(context, listen: false);
                question_script.category_daily = index + 9;

                await question_script.fetchQuestion().then((value) =>
                    question_script.request_code == 0
                        ? Navigator.of(context)
                            .pushReplacementNamed(QuizScreen.routename)
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'No Question in this list right now.'))));
              },
              child: Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    height: 90,  
                    child: Stack(clipBehavior: Clip.none, children: [
                      Row(
                        children: [
                          Container(
                              color: Colors.grey,
                              child:
                                  Image.asset('assets/images/home_screen.png')),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, bottom: 10),
                                  child: Text(
                                    category[index],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Gilroy',
                                        letterSpacing: .5),
                                  ),
                                ),
                                Text(
                                  category[index] + " of the Day",
                                  style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontSize: 14,
                                      color: Colors.grey.shade500),
                                )
                              ]),
                        ],
                      ),
                      Positioned(
                        top: -3,
                        right: -3,
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            height: 30,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))),
                          ),
                          const Text(
                            '10 Questions',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                color: Colors.white),
                          )
                        ]),
                      )
                    ]),
                  )),
            );
          },
          itemCount: category.length,
        ),
      ),
    );
  }
}

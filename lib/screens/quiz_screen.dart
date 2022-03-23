import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Widgets/myAppBar.dart';
import 'package:quiz_app/providers/questions.dart';
import 'package:quiz_app/screens/result_screen.dart';

class QuizScreen extends StatefulWidget {
  static const routename = '/quiz-screen';

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

int correct_answer_count = 0;

class _QuizScreenState extends State<QuizScreen> {
  var question_index = 0;

  @override
  Widget build(BuildContext context) {
    var question_script = Provider.of<Questions>(
      context,
    );
    
    return Scaffold(
      appBar: MyAppBar("Quiz", () {
        question_script.question = [];
        question_script.correct_answers_list = [];
        Navigator.of(context).pop();
      }),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${question_index + 1}/10',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${question_script.category_daily}',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: Text(
                question_script.question_Setter(question_index),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold),
              ),
            ),
            gameOptionStyle(
                question_script.optionSetter(question_index, 0), context),
            gameOptionStyle(
                question_script.optionSetter(question_index, 1), context),
            gameOptionStyle(
                question_script.optionSetter(question_index, 2), context),
            gameOptionStyle(
                question_script.optionSetter(question_index, 3), context),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  screenChangeButton(
                      context, Alignment.bottomRight, '< Previous', () {
                    setState(() {
                      if (question_index > 0) {
                        question_index--;
                      }
                    });
                  }),
                  screenChangeButton(context, Alignment.bottomLeft, 'Next >',
                      () {
                    setState(() {
                      if (question_index < 9) {
                        question_index++;
                      } else {
                        Navigator.of(context).pushReplacementNamed(
                            ResultScreen.routename,
                            arguments: correct_answer_count);
                      }
                    });
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell gameOptionStyle(String option, BuildContext context) {
    var question_script = Provider.of<Questions>(
      context,
    );

    return InkWell(
      onTap: () {
        setState(() {
          if (question_index < 9) {
            if (question_script.correct_answers_list.contains(option)) {
              ++correct_answer_count;
            }
            question_index++;
          } else {
            if (question_script.correct_answers_list.contains(option)) {
              ++correct_answer_count;
            }
            Navigator.of(context).pushReplacementNamed(ResultScreen.routename,
                arguments: correct_answer_count);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 70,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/box_.png',
              width:
                  double.infinity, //It helps to achieve the full stretched box.
              fit: BoxFit.fill,
            ),
            Text(
              option,
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu'),
            )
          ],
        ),
      ),
    );
  }

  Container screenChangeButton(BuildContext context, Alignment align,
      String title, VoidCallback question_changer) {
    return Container(
        padding: const EdgeInsets.only(bottom: 40),
        alignment: align,
        child: ElevatedButton(
          onPressed: question_changer,
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontFamily: 'Ubuntu'),
          ),
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor.withOpacity(0.7),
              elevation: 5,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shadowColor: Colors.grey,
              shape: const StadiumBorder()),
        ));
  }
}

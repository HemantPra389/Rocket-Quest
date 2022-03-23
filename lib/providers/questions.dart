import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quiz_app/models/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Questions extends ChangeNotifier {
  List<Question> question = [];
  List<String> correct_answers_list = [];
  int category_daily = 0;
  var request_code = 0;
  String questions_level = 'easy';

  String url_achiever(int category, String newlevel) {
    var url =
        "https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple";
    url =
        "https://opentdb.com/api.php?amount=10&category=$category&difficulty=$questions_level&type=multiple";
    return url;
  }

  Future<void> storeLevel(String level) async {
    questions_level = level;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("current_level", level);
  }

  Future<void> storeBoolean(bool setting_level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setting_bool', setting_level);
  }

  Future<void> recieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    questions_level = prefs.getString('current_level').toString();
  }

  Future<void> fetchQuestion() async {
    var response = await http
        .get(Uri.parse(url_achiever(category_daily, questions_level)));
    var extractedData = json.decode(response.body);
    if (extractedData['response_code'] == 0) {
      for (int i = 0; i <= 9; i++) {
        question.add(Question(
          id: i,
          question: extractedData['results'][i]["question"],
          options: [
            extractedData['results'][i]['correct_answer'],
            extractedData['results'][i]['incorrect_answers'][0],
            extractedData['results'][i]['incorrect_answers'][1],
            extractedData['results'][i]['incorrect_answers'][2],
          ],
        ));
        correct_answers_list.add(extractedData['results'][i]['correct_answer']);

        question[i].options.shuffle();
      }
      request_code = 0;
      notifyListeners();
    } else {
      request_code = 1;
      notifyListeners();
    }
  }

  String question_Setter(int questionIndex) {
    return question[questionIndex].question;
  }

  String optionSetter(int questionIndex, int optionIndex) {
    return question[questionIndex].options[optionIndex];
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/authProvider.dart';
import 'package:quiz_app/providers/questions.dart';
import 'package:quiz_app/providers/users_data.dart';
import 'package:quiz_app/screens/auth_screen.dart';
import 'package:quiz_app/screens/daily_quesion_screen.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

String isAuth() {
  if (FirebaseAuth.instance.currentUser != null) {
    return HomeScreen.routename;
  }
  return '/';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Questions(),
        ),
        ChangeNotifierProvider(
          create: (context) => UsersData(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(131, 89, 163, 1),
          textTheme: const TextTheme(
            caption: TextStyle(color: Color.fromRGBO(131, 89, 163, .8)),
          ),
        ),
        initialRoute: isAuth(),
        routes: {
          '/': (ctx) => MyHomePage(),
          AuthScreen.routename: (ctx) => AuthScreen(),
          SettingScreen.routename: (ctx) => SettingScreen(),
          HomeScreen.routename: (ctx) => HomeScreen(),
          QuizScreen.routename: (ctx) => QuizScreen(),
          ResultScreen.routename: (ctx) => ResultScreen(),
          DailyQuestionScreen.routename: (ctx) => DailyQuestionScreen()
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: IntroductionScreen(
          pages: [
            PageViewModel(
                title: "Quiz App",
                body:
                    "Answer a question & get a chance to win existing prizes!!!",
                image: Center(
                    child: Image.asset(
                  'assets/images/superman.png',
                  height: 300,
                  width: 500,
                )),
                decoration: getDecoration(50, 40)),
            PageViewModel(
                title: "",
                body: "Just answer few easy questions & get what you want",
                image: Center(
                    child: Image.asset(
                  'assets/images/question.png',
                  height: 300,
                  width: 500,
                )),
                decoration: getDecoration(0, 80)),
            PageViewModel(
                title: "",
                body:
                    "Win Exciting Prizes by answering few questions of a quiz",
                image: Center(
                    child: Image.asset(
                  'assets/images/winner.png',
                  height: 300,
                  width: 500,
                )),
                decoration: getDecoration(0, 80)),
            PageViewModel(
                title: '',
                body: "Answering each question of the quiz in maximum time",
                image: Center(
                    child: Image.asset(
                  'assets/images/time.png',
                  height: 300,
                  width: 500,
                )),
                decoration: getDecoration(0, 40),
                footer: onBordingButton(context, 'Start', () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthScreen()));
                }))
          ],
          isProgressTap: false,
          dotsDecorator: DotsDecorator(
              size: const Size(15, 15),
              activeSize: const Size(22, 10),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          showSkipButton: true,
          showDoneButton: false,
          nextFlex: 0,
          skipOrBackFlex: 0,
          animationDuration: 500,
          skip: const Text(
            'Skip',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          next: const Icon(Icons.arrow_forward, color: Colors.black, size: 30)),
    ));
  }

  ElevatedButton onBordingButton(
      BuildContext context, String title, VoidCallback myFun) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
          primary: Theme.of(context).primaryColor,
        ),
        child: Text(title,
            style: const TextStyle(fontSize: 20, color: Colors.white)),
        onPressed: () {
          myFun();
        });
  }

  PageDecoration getDecoration(double titlefontsize, double bodyPadding) {
    return PageDecoration(
        titleTextStyle: TextStyle(
          color: Colors.deepPurple,
          fontSize: titlefontsize,
          fontWeight: FontWeight.bold,
          fontFamily: 'Gilroy',
        ),
        imageFlex: 0,
        bodyTextStyle: TextStyle(
            fontFamily: 'Gilroy', fontSize: 22, color: Colors.grey.shade700),
        bodyPadding: EdgeInsets.only(top: bodyPadding, left: 30, right: 30),
        imagePadding: const EdgeInsets.only(top: 150, bottom: 30));
  }
}

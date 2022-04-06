import 'package:flutter/material.dart';

PreferredSize MyAppBar(String title, Function myFun) {
  return PreferredSize(
    preferredSize: Size.fromHeight(80),
    child: SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 10),
        child: AppBar(
          elevation: 0,
          primary: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              myFun();
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.grey.shade800,
          ),
          title: Text(
            title,
            style: TextStyle(
                color: Colors.grey.shade800,
                fontFamily: 'Gilroy',
                fontSize: 26),
          ),
          centerTitle: true,
        ),
      ),
    ),
  );
}

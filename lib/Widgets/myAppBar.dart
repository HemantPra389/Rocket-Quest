import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Function myFun;
  MyAppBar(this.title, this.myFun);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: double.infinity,
      child: Stack(
        children: [
          IconButton(
              onPressed: () {
                myFun();
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
                size: 35,
              )),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Gilroy',
                  color: Colors.grey.shade600),
            ),
          )
        ],
      ),
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

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

// SafeArea(
//         child: Container(
//       width: double.infinity,
//       child: Stack(
//         children: [
//           IconButton(
//               onPressed: () {
//                 myFun();
//               },
//               icon: const Icon(
//                 Icons.keyboard_arrow_left,
//                 size: 35,
//               )),
//           Container(
//             alignment: Alignment.center,

//             child: Text(
//               title,
//               style: TextStyle(
//                   fontSize: 24,
//                   fontFamily: 'Gilroy',
//                   color: Colors.grey.shade600),
//             ),
//           )
//         ],
//       ),
//     ));
}

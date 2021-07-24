import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesk_app/core/components/bottomBar.dart';
import 'package:gesk_app/core/components/buttonIcon.dart';

import 'core/components/butonMini.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = true;
    if (auth) {
      return Scaffold(
        body: Center(
          child: ButtonMini.active(
            text: "helo",
            onPressed: (){
              print("helo");
            },
          )
        ),
        bottomNavigationBar: BottomBar()
      );
    }else{
      return Scaffold();
    }
  }
}
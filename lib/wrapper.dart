import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesk_app/views/giris/MapScreen.dart';
import 'package:gesk_app/views/giris/MapScreen_readOnly.dart';





// ignore: must_be_immutable
class Wrapper extends StatelessWidget {
  bool auth;
  Wrapper({Key key,bool auth}) : super(key: key){
    auth = this.auth;
  }

  

  @override
  Widget build(BuildContext context) {
    var auth = true;
    if (auth) {
      return MapScreen();
    }else{
      return MapScreenReadOnly();
    }
  }
}
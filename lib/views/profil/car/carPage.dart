import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesk_app/core/colors.dart';
import 'package:gesk_app/core/components/textInput.dart';
import 'package:gesk_app/models/car.dart';
import 'package:gesk_app/views/profil/profileScreen.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CarPAge extends StatefulWidget {
  Car car;
  CarPAge({Key key, this.car}) : super(key: key);

  @override
  _CarPAgeState createState() => _CarPAgeState(car);
}

class _CarPAgeState extends State<CarPAge> {
  _CarPAgeState(this.car);
  Car car;

  TextEditingController _plakaController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _renkController = TextEditingController();

  FocusNode _plakaFocus = FocusNode();
  FocusNode _modelFocus = FocusNode();
  FocusNode _renkFocus = FocusNode();

  var edit1 = true.obs;
  var edit2 = true.obs;
  var edit3 = true.obs;

  @override
  Widget build(BuildContext context) {
    String plaka = car.plaka;
    String model = car.model.toString();
    String renk = car.renk;
    _plakaController.text = plaka ?? "null";
    _modelController.text = model ?? "null";
    _renkController.text = renk ?? "null";

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Spacer(
              flex: 8,
            ),
            Expanded(
              child: _buildBackButton(),
              flex: 44,
            ),
            Spacer(
              flex: 24,
            ),
            Expanded(flex: 166, child: _buildPano()),
            Spacer(
              flex: 32,
            ),
            Expanded(
                flex: 60,
                child: TextInputSimple(
                  readOnly: edit1.value,
                  suffixIcon: Icon(edit1.value
                      ? CupertinoIcons.pen
                      : CupertinoIcons.check_mark),
                  suffixFunc: () {
                    setState(() {
                      edit1.value = !edit1.value;
                      car.plaka = _plakaController.text;
                    });
                  },
                  prefixIcon: Icon(
                    CupertinoIcons.barcode_viewfinder,
                    color: blue500,
                  ),
                  onTap: () {
                    print(_plakaController.text);
                  },
                  focusNode: _plakaFocus,
                  controller: _plakaController,
                )),
            Spacer(
              flex: 24,
            ),
            Expanded(
              flex: 60,
              child: TextInputSimple(
                readOnly: edit2.value,
                suffixIcon: Icon(edit2.value
                    ? CupertinoIcons.pen
                    : CupertinoIcons.check_mark),
                suffixFunc: () {
                  setState(() {
                    edit2.value = !edit2.value;
                    car.renk = _renkController.text;
                  });
                },
                prefixIcon: Icon(
                  CupertinoIcons.question,
                  color: blue500,
                ),
                focusNode: _renkFocus,
                controller: _renkController,
              ),
            ),
            Spacer(
              flex: 24,
            ),
            Expanded(
              flex: 60,
              child: TextInputSimple(
                readOnly: edit3.value,
                suffixIcon: Icon(edit3.value
                    ? CupertinoIcons.pen
                    : CupertinoIcons.check_mark),
                suffixFunc: () {
                  setState(() {
                    car.model = int.parse(_modelController.text); 
                    edit3.value = !edit3.value;
                  });
                },
                prefixIcon: Icon(
                  CupertinoIcons.calendar,
                  color: blue500,
                ),
                focusNode: _modelFocus,
                controller: _modelController,
              ),
            ),
            Spacer(
              flex: 120,
            ),
            Expanded(
                flex: 18,
                child: InkWell(
                  onTap: _deleteCarTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bu aracı kalıcı olarak ",
                        style: TextStyle(color: gray900),
                      ),
                      Text(
                        "silmek",
                        style: TextStyle(
                            color: gray900, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        " istiyorum.",
                        style: TextStyle(color: gray900),
                      )
                    ],
                  ),
                )),
            Spacer(
              flex: 136,
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPano() {
    return Container(
      width: Get.width / 375 * 343,
      height: Get.height / 812166,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xfff2f2f7),
      ),
      child: Column(
        children: [
          Spacer(
            flex: 16,
          ),
          Expanded(
            flex: 96,
            child: Container(
              width: Get.width / 375 * 96,
              decoration: BoxDecoration(
                  color: blue500, borderRadius: BorderRadius.circular(16)),
              child: Icon(
                CupertinoIcons.car_detailed,
                color: white,
                size: 34,
              ),
            ),
          ),
          Spacer(
            flex: 16,
          ),
          Expanded(
            flex: 22,
            child: Text(
              car.plaka,
              style: TextStyle(
                color: black,
                fontSize: 22,
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacer(
            flex: 16,
          )
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        child: GestureDetector(
          onTap: () => _backButtonFunc(),
          child: Row(
            children: [
              Icon(CupertinoIcons.left_chevron, color: blue500),
              Text(
                "Geri",
                style: TextStyle(fontSize: 17, color: blue500),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _backButtonFunc() {
    Get.to(()=>ProfileScreen());
  }

  void _deleteCarTap() {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Tanımlı aracı sil"),
        content: Container(
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Daha önce tanımlamış olduğunuz",textAlign: TextAlign.left),
              Text("${car.plaka} plakalı araç silinecektir.")
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: _cancleFunc, child: Text("Reddet",style: TextStyle(color: gray900),)),
          TextButton(onPressed: _deleteFunc, child: Text("Kabul Et")),
        ],
      );
    });
  }

  void _deleteFunc(){
    print("delete car");
    Get.to(()=>ProfileScreen());
  }

  void _cancleFunc(){
    Navigator.pop(context);
  }
}
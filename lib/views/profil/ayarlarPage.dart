import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesk_app/backend/dataService.dart';
import 'package:gesk_app/core/colors.dart';
import 'package:gesk_app/core/components/bottomBar.dart';
import 'package:gesk_app/core/components/button.dart';
import 'package:gesk_app/core/components/textInput.dart';
import 'package:gesk_app/views/profil/profileScreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AyarlarPage extends StatefulWidget {
  const AyarlarPage({Key key}) : super(key: key);

  @override
  _AyarlarPageState createState() => _AyarlarPageState();
}

class _AyarlarPageState extends State<AyarlarPage> {
  final int _index =2;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _nameFocus = FocusNode();
  FocusNode _mailFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  var edit1 = true.obs;
  var edit2 = true.obs;
  var edit3 = true.obs;
  var edit4 = true.obs;

  var _changed = false.obs;
  var _w = Get.width / 375;
  var _h = Get.height / 812;
  String name = "";
  String phoneNumber = "";
  String mail = "";
  String password = "";

@override
void initState() { 
  super.initState();
  getInfo();
}

  @override
  Widget build(BuildContext context) {
    _nameController.text = name;
    _phoneController.text = phoneNumber;
    _mailController.text = mail;
    _passwordController.text = password;

    return Scaffold(
      bottomNavigationBar: BottomBar(index: _index,),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _body(context),
          )
        ],
      ),
    );
  }

  Column _body(BuildContext context) {
    return Column(
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
          flex: 8,
        ),
        Expanded(
          flex: 220,
          child: Column(
            children: [
              Spacer(
                flex: 24,
              ),
              Expanded(
                child: _buildPhotoFrame(),
                flex: 60,
              ),
              Spacer(
                flex: 16,
              ),
              Expanded(
                child: _buildNameBar(),
                flex: 22,
              ),
              Spacer(
                flex: 8,
              ),
              Expanded(
                child: _buildPhoneNumber(),
                flex: 22,
              ),
              Spacer(
                flex: 24,
              )
            ],
          ),
        ),
        Spacer(
          flex: 16,
        ),
        Expanded(
            flex: 393,
            child: Column(
              children: [
                Spacer(
                  flex: 8,
                ),
                Expanded(
                  child: _buildName(),
                  flex: 70,
                ),
                Spacer(
                  flex: 16,
                ),
                Expanded(
                  child: _buildPhone(),
                  flex: 70,
                ),
                Spacer(
                  flex: 16,
                ),
                Expanded(
                  child: _buildMail(),
                  flex: 70,
                ),
                Spacer(
                  flex: 16,
                ),
                Expanded(
                  child: _buildPassword(),
                  flex: 50,
                ),
                Spacer(
                  flex: 16,
                ),
                Expanded(
                  child: _buildButton(),
                  flex: 60,
                ),
                Spacer(flex: 200,)
              ],
            ))
      ],
    );
  }

  _buildButton() {
    
    return Button.active(text: "Kaydet", onPressed: _kaydet);
    
  }

  _buildName() {
    return TextInputSimple(
      onChange: () {
        _changed.value = true;
      },
      controller: _nameController,
      focusNode: _nameFocus,
      prefixIcon: Icon(CupertinoIcons.person),
      readOnly: edit1.value,
      suffixIcon:
          Icon(edit1.value ? CupertinoIcons.pen : CupertinoIcons.check_mark),
      suffixFunc: () {
        setState(() {
          edit1.value = !edit1.value;
          name = _nameController.text;
        });
      },
    );
  }

  _buildPhone() {
    return TextInputSimple(
      onChange: () {
        _changed.value = true;
      },
      controller: _phoneController,
      focusNode: _phoneFocus,
      prefixIcon: Icon(CupertinoIcons.phone),
      readOnly: edit2.value,
      suffixIcon:
          Icon(edit2.value ? CupertinoIcons.pen : CupertinoIcons.check_mark),
      suffixFunc: () {
        setState(() {
          edit2.value = !edit2.value;
          phoneNumber = _phoneController.text;
        });
      },
    );
  }

  _buildMail() {
    return TextInputSimple(
      onChange: () {
        _changed.value = true;
      },
      controller: _mailController,
      focusNode: _mailFocus,
      prefixIcon: Icon(CupertinoIcons.mail),
      readOnly: edit3.value,
      suffixIcon:
          Icon(edit3.value ? CupertinoIcons.pen : CupertinoIcons.check_mark),
      suffixFunc: () {
        setState(() {
          edit3.value = !edit3.value;
          mail = _nameController.text;
        });
      },
    );
  }

  _buildPassword() {
    var _focused = false.obs;
    var _secure = true.obs;
    return Obx(() => Container(
          width: Get.width / 375 * 343,
          height: Get.height / 812 * 44,
          decoration: BoxDecoration(
              border: _focused.value
                  ? Border.all(color: blue500)
                  : Border.all(color: gray500,width: 2),

              borderRadius: BorderRadius.circular(8),
              color: white),
          padding: EdgeInsets.only(
            right: 8,
            left: 8,
          ),
          child: TextFormField(
            onChanged: (val) {
              _changed.value = true;
            },
            readOnly: edit4.value,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocus,
            obscureText: _secure.value,
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "Parola",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusColor: blue500,
              prefixIcon: Icon(CupertinoIcons.lock),
              suffixIcon: Container(
                height: Get.height / 812 * 30,
                child: IconButton(
                  icon: _secure.value
                      ? Icon(CupertinoIcons.eye_fill)
                      : Icon(CupertinoIcons.check_mark),
                  onPressed: () {
                    _secure.value = !_secure.value;
                    edit4.value = !edit4.value;
                    password = _passwordController.text;
                  },
                ),
              ),
            ),
          ),
        ));
  }

  _buildPhotoFrame() {
    return Container(
      width: _w * 96,
      height: _h * 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0x3f000000),
            blurRadius: 10,
            offset: Offset(4, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  _buildNameBar() {
    return Container(
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: black,
          fontSize: 22,
          fontFamily: "SF Pro Display",
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _buildPhoneNumber() {
    return Container(
      child: Text(
        phoneNumber,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: gray900,
          fontSize: 13,
        ),
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

  getInfo()async{
    var _prefs =await SharedPreferences.getInstance();

    var _userId = _prefs.getInt("userId");

    var _user = await DataService().getUser(userId: _userId);

    setState(() {
          name = _user.name;
          mail = _user.mail;
          phoneNumber = _user.phoneNumber;
          password = _user.password;
        });
  }

  setInfo()async{
        var _prefs =await SharedPreferences.getInstance();

    var _userId = _prefs.getInt("userId");

    DataService().editUser(
      userId: _userId,
      name: _nameController.text,
      mail: _mailController.text,
      phone: _phoneController.text,
      password: _passwordController.text
    );

  }

  void _kaydet() {
    setInfo();
    Get.to(()=> ProfileScreen());
  }
}

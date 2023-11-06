import 'dart:convert';
import 'package:achievement_view/achievement_view.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:chat_app/widgets/GradientButton.dart';
import 'package:chat_app/widgets/rounded_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  ///Text Editing Controllers
  TextEditingController oldPasswordController = TextEditingController(text: '');
  TextEditingController newPasswordController = TextEditingController(text: '');
  TextEditingController retypePasswordController =
      TextEditingController(text: '');
  bool loading = false;
  String? username;

  getUserName() async {
    username = await LocalStorage().getString("username");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        flexibleSpace: SafeArea(
          child: Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: mycolor,
              border: Border.all(
                color: mycolor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Change Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  "Old Password",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            _input("", oldPasswordController),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "New Password",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            _input("", newPasswordController),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Retype Password",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            _input("", retypePasswordController),
            SizedBox(height: 50),
            loading
                ? CircularProgressIndicator()
                : Container(
                    width: 250,
                    height: 50,
                    child: Hero(
                      tag: "Login",
                      child: GradientButton(
                        title: "Submit",
                        clrs: [mycolor, mycolor],
                        onpressed: () {
                          update();
                        },
                      ),
                    ),
                  ),
            SizedBox(height: 25),
          ]),
        ),
      ),
    );
  }

  update() async {
    loading = true;
    setState(() {});
    final apiResponse = await HttpService.post(Api.changePassword, {
      "username": username,
      "oldpassword": oldPasswordController.text,
      "newpassword": newPasswordController.text,
      "cpassword": retypePasswordController.text,
    });
    final result = jsonDecode(apiResponse.data);
    print(result);
    if (result["Status"] == "succcess") {
      AchievementView(
        context,
        color: Color(0xFF072A6C),
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
        title: "Success!",
        elevation: 20,
        subTitle: "Password reset successfully",
        isCircle: true,
      ).show();
      Navigator.pop(context);
    } else {
      Get.defaultDialog(
              title: "${result["Report"]}",
              titleStyle: TextStyle(
                  color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
              middleText: "Your input fields could not be updated",
              middleTextStyle: TextStyle(color: Color(0xFF072A6C)))
          .then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false,
      bool readOnly = false,
      TextInputType type = TextInputType.text}) {
    return RoundedTextField(
      hint: hint,
      type: TextInputType.text,
      obsecureText: false,
      icon: Icon(
        Icons.badge,
        color: Color(0xff00AEFF),
      ),
      iconColor: Colors.cyan,
      controller: controller,
      onChange: (text) {},
    );
  }
}

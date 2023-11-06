import 'dart:convert';
import 'package:chat_app/constants.dart';
import 'package:chat_app/forgot_password.dart';
import 'package:chat_app/registration.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:chat_app/user_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class Sign_in_screen extends StatefulWidget {
  @override
  _Sign_in_screenState createState() => _Sign_in_screenState();
}

class _Sign_in_screenState extends State<Sign_in_screen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 20, top: 60),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //image
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Image.asset(
                          "images/pbo-nobg.png",
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      /*Text(
                        "Welcome Back",
                        style: TextStyle(
                            color: Color(0xff2C2627),
                            fontFamily: 'ProximaNova-Regular',
                            fontWeight: FontWeight.w700,
                            fontSize: 31),
                      ),*/
                      /*SizedBox(
                        height: 10,
                      ),*/
                      /*Text(
                        "Sign in to continue",
                        style: TextStyle(
                            color: Color(0xff2C2627),
                            fontFamily: 'ProximaNova-Regular',
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),*/
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),

                      Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  //Email
                                  TextFormField(
                                    controller: usernameController,
                                    cursorColor: mycolor,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mycolor)),
                                      labelText: 'Username ',
                                      labelStyle: TextStyle(
                                          color: Color(0xffABA5A5),
                                          fontFamily: 'ProximaNova-Regular',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.51),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),

                                  //Password
                                  TextFormField(
                                    controller: passwordController,
                                    cursorColor: mycolor,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: mycolor)),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                            color: Color(0xffABA5A5),
                                            fontFamily: 'ProximaNova-Regular',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.51)),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length <= 5) {
                                        return 'invalid password';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ForgotPassword()));
                    },
                    child: Text("Forgot Password?",
                        style: TextStyle(
                            color: Colors.pink,
                            fontFamily: 'ProximaNova-Regular',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.69)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.037,
                  ),
                  loading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontFamily: 'ProximaNova-Regular',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.51),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.purple,
                            textColor: Colors.white70,
                            onPressed: () {
                              signin();
                            },
                          ),
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.027,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account?  "),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => Registration()));
                          },
                          child: Text("Sign up",
                              style: TextStyle(
                                color: Colors.pink,
                              ))),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  signin() async {
    loading = true;
    setState(() {});
    try {
      final apiResult = await HttpService.post(
        Api.login,
        {
          "username": usernameController.text,
          "password": passwordController.text,
        },
      );
      print(apiResult.data);
      //Map<String, String> result = apiResult.data as Map<String, String>;
      final result = jsonDecode(apiResult.data);
      print(result);
      if (result["Report"] == "Sucess") {
        LocalStorage().setString("username", usernameController.text);
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: UserNavigation(
                  username: usernameController.text,
                )),
            (route) => false);
      } else {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bug_report,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "${result["Report"]}",
                      style: TextStyle(
                          color: Color(0xFF072A6C),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                insetPadding: EdgeInsets.all(15),
                content: Text("Please check your sign in credentials")));
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Error",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "Please check your internet connection and try again",
        middleTextStyle: TextStyle(color: Color(0xFF072A6C)),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }
}

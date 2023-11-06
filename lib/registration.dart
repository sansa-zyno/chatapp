import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:chat_app/login.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:chat_app/user_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 20, top: 65),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            child: Image.asset("images/pbo-nobg.png"),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          /* Text(
                            "Signup",
                            style: TextStyle(
                                color: Color(0xff2C2627),
                                fontFamily: 'ProximaNova-Regular',
                                fontWeight: FontWeight.w700,
                                fontSize: 31),
                          ),*/
                        ],
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                //name
                                TextFormField(
                                  cursorColor: mycolor,
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mycolor)),
                                      labelText: 'Username',
                                      labelStyle: TextStyle(
                                          color: Color(0xffABA5A5),
                                          fontFamily: 'ProximaNova-Regular',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.51)),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: firstNameController,
                                  cursorColor: mycolor,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mycolor)),
                                      labelText: 'First Name',
                                      labelStyle: TextStyle(
                                          color: Color(0xffABA5A5),
                                          fontFamily: 'ProximaNova-Regular',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.51)),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                ),

                                TextFormField(
                                  cursorColor: mycolor,
                                  controller: lastNameController,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mycolor)),
                                      labelText: 'Last Name',
                                      labelStyle: TextStyle(
                                          color: Color(0xffABA5A5),
                                          fontFamily: 'ProximaNova-Regular',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.51)),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                ),

                                //Email
                                TextFormField(
                                  cursorColor: mycolor,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mycolor)),
                                      labelText: 'Email ',
                                      labelStyle: TextStyle(
                                          color: Color(0xffABA5A5),
                                          fontFamily: 'ProximaNova-Regular',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.51)),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*Required";
                                    }
                                    if (!value.contains('@')) {
                                      return 'invalid email';
                                    }
                                    return null;
                                  },
                                ),

                                //Phone Number
                                TextFormField(
                                  cursorColor: mycolor,
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mycolor)),
                                      labelText: 'Phone Number',
                                      labelStyle: TextStyle(
                                          color: Color(0xffABA5A5),
                                          fontFamily: 'ProximaNova-Regular',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.51)),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*Required";
                                    }

                                    return null;
                                  },
                                ),

                                //Password
                                TextFormField(
                                  cursorColor: mycolor,
                                  controller: passwordController,
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
                                    bool passValid = RegExp(
                                            "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*")
                                        .hasMatch(value!);
                                    if (value.isEmpty) {
                                      return '*Required';
                                    }
                                    if (value.length < 5) {
                                      return '*Password is too short';
                                    }
                                    if (!passValid) {
                                      return 'Weak password';
                                    }
                                    return null;
                                  },
                                ),

                                //Confirm password
                                TextFormField(
                                  cursorColor: mycolor,
                                  controller: confirmPasswordController,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mycolor)),
                                      labelText: 'Confirm Password',
                                      labelStyle: TextStyle(
                                          color: Color(0xffABA5A5),
                                          fontFamily: 'ProximaNova-Regular',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.51)),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*Required";
                                    }
                                    if (value !=
                                        confirmPasswordController.text) {
                                      return 'invalid password';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(height: 15),
                    loading == true
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.only(left: 7, right: 25),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              child: RaisedButton(
                                child: Text('SIGN UP',
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontFamily: 'ProximaNova-Regular',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.51)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.35),
                                ),
                                color: Colors.purple,
                                textColor: Colors.white,
                                onPressed: () async {
                                  signup();
                                },
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?  "),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => Sign_in_screen()));
                            },
                            child: Text("Login",
                                style: TextStyle(
                                  color: Colors.pink,
                                ))),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  signup() async {
    loading = true;
    setState(() {});
    try {
      final apiResult = await HttpService.post(
        Api.register,
        {
          "username": usernameController.text,
          "firstname": firstNameController.text,
          "lastname": lastNameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
          "password2": confirmPasswordController.text
        },
      );
      print(apiResult);
      final result = jsonDecode(apiResult.data);
      print(result);
      if (result["Report"] == "Success") {
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
                content: Text("Please check your sign up credentials")));
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

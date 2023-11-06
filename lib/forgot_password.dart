import 'dart:convert';
import 'package:chat_app/login.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ///Text Editing Controllers
  TextEditingController emailController = TextEditingController(text: '');
  bool loading = false;
  String? username;
  getUserName() async {
    username = await LocalStorage().getString("username");
  }

  reset() async {
    loading = true;
    setState(() {});
    final res = await HttpService.post(Api.fogotPassword,
        {"username": username, "email": emailController.text});
    final result = jsonDecode(res.data);
    print(result);
    if (result["Status"] == "succcess") {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "",
        middleTextStyle: TextStyle(color: Color(0xFF072A6C)),
      ).then((value) => print("done"));
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "",
        middleTextStyle: TextStyle(color: Color(0xFF072A6C)),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
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
      body: Container(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: ListView(children: [
          SizedBox(
            height: 50,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.asset(
              "images/pbo-nobg.png",
            ),
          ),
          SizedBox(height: 50),
          Center(
            child: Text(
              "Forgot Password",
              style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF072A6C),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 50),
          Row(
            children: [
              Text("Email",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter email", emailController),
          SizedBox(
            height: 50,
          ),
          loading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: InkWell(
                      onTap: () {
                        reset();
                      },
                      child: Text("Submit",
                          style: TextStyle(
                            color: Color(0xFF072A6C),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))),
                ),
          SizedBox(
            height: 25,
          ),
          Center(
              child: Text("Already have an account ?",
                  style: TextStyle(color: Colors.grey))),
          SizedBox(
            height: 15,
          ),
          Center(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        child: Sign_in_screen()),
                  );
                },
                child: Text("Sign In",
                    style: TextStyle(
                      color: Color(0xFF072A6C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
          ),
        ]),
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: Color(0xFF072A6C)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(2, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 15, 0),
        child: TextFormField(
          cursorColor: Color(0xFF072A6C),
          obscureText: obscure,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "This field must not be empty.";
            }
            return null;
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
              //labelText: label,
              hintText: hint,
              focusColor: Colors.grey,

              //fillColor: Colors.white,

              fillColor: Colors.white),
          //keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}

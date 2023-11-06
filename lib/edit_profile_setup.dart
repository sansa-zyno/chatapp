import 'dart:convert';
import 'dart:developer';
import 'package:achievement_view/achievement_view.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:chat_app/widgets/GradientButton.dart';
import 'package:chat_app/widgets/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ///Text Editing Controllers
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController descController = TextEditingController(text: '');
  bool loading = false;
  bool onPageLoad = false;
  String? username;

  OnPageLoad() async {
    onPageLoad = true;
    setState(() {});
    username = await LocalStorage().getString("username");
    log(username!);
    final res =
        await HttpService.post(Api.getProfileDetails, {"username": username});
    Map result = jsonDecode(res.data)[0];
    firstNameController.text = result["Firstname"] ?? "";
    lastNameController.text = result["Lastname"] ?? "";
    emailController.text = result["Email"] ?? "";
    phoneController.text = result["Phone"] ?? "";
    onPageLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OnPageLoad();
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
                        "Edit Profile",
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
        body: onPageLoad
            ? Center(child: SpinKitDualRing(color: mycolor))
            : Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          "First Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", firstNameController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Last Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", lastNameController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", phoneController, type: TextInputType.phone),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", emailController,
                        readOnly: emailController.text == "" ? false : true),
                    SizedBox(height: 50),
                    loading
                        ? Center(child: CircularProgressIndicator())
                        : GradientButton(
                            title: "Submit",
                            onpressed: () {
                              update();
                            },
                            clrs: [mycolor, mycolor],
                          ),
                    SizedBox(height: 25),
                  ],
                ),
              ));
  }

  update() async {
    loading = true;
    setState(() {});
    final apiResponse = await HttpService.post(Api.editProfile, {
      "username": username,
      "firstname": firstNameController.text,
      "lastname": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
    });
    final result = jsonDecode(apiResponse.data);
    print(result);
    if (result["Status"] == "succcess") {
      AchievementView(
        context,
        alignment: Alignment.topRight,
        color: Color(0xFF072A6C),
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
        title: "Success!",
        elevation: 20,
        subTitle: "Profile updated successfully",
        isCircle: true,
      ).show();
      Navigator.pop(context);
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "Your input fields could not be updated",
        middleTextStyle: TextStyle(color: Color(0xFF072A6C)),
      ).then((value) => print("done"));
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

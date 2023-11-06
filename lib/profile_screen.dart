import 'dart:convert';
import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:chat_app/change_password.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/edit_profile_setup.dart';
import 'package:chat_app/login.dart';
import 'package:chat_app/provider/app_provider.dart';
import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routename = "profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _switch = false;
  XFile? image;
  String imageUrl = "";
  String? username;
  Map result = {};

  getUserData(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    username = await LocalStorage().getString("username");
    final res =
        await HttpService.post(Api.getProfileDetails, {"username": username});
    result = jsonDecode(res.data)[0];
    setState(() {});
    appProvider.getImage(username!);
  }

  uploadImage(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      Response res = await HttpService.postWithFiles(Api.profilePics, {
        "username": username,
        "image": MultipartFile.fromBytes(File(image!.path).readAsBytesSync(),
            filename: image!.name)
      });
      final result = jsonDecode(res.data);
      if (result["Status"] == "succcess") {
        appProvider.getImage(username!);
        setState(() {});
        AchievementView(
          context,
          color: Color(0xFF072A6C),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          title: "Success!",
          elevation: 20,
          subTitle: "Profile picture uploaded successfully",
          isCircle: true,
        ).show();
      } else {
        AchievementView(
          context,
          color: Colors.red,
          icon: Icon(
            Icons.bug_report,
            color: Colors.white,
          ),
          title: "Failed!",
          elevation: 20,
          subTitle: "Profile picture upload failed",
          isCircle: true,
        ).show();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 178,
                  decoration: BoxDecoration(
                    color: mycolor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 67),
                        child: Container(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //username
                                  Container(
                                    height: 30,
                                    width: 200,
                                    child: Row(
                                      children: [
                                        Text(
                                          username != null ? username! : "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        /*IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 19,
                                            ))*/
                                      ],
                                    ),
                                  ),
                                  //mobile number
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                result["Email"] != null ? result["Email"] : "",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40, right: 35),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              InkWell(
                                onTap: () {
                                  uploadImage(context);
                                },
                                child: CircleAvatar(
                                  radius: 45,
                                  child: appProvider.imageUrl != ""
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          child: Image.network(
                                            appProvider.imageUrl,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Center(
                                          child: Image.asset(
                                          "images/user.png",
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        )),
                                ),
                              ),
                              /*CircleAvatar(
                                  maxRadius: 13,
                                  backgroundColor: Colors.indigo,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.camera_alt, size: 14),
                                    color: Colors.white,
                                  ))*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: mycolor)),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: ((context) => Sign_in_screen())),
                              ((route) => false));
                          LocalStorage().clearPref();
                        },
                        child: Text(
                          "Log out",
                        ))),
              ],
            ),
          );
        },
      ),
    );
  }
}

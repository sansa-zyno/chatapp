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

class SettingScreen extends StatefulWidget {
  static const routename = "setting_screen";

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _switch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    AppProvider appProvider = Provider.of<AppProvider>(context);
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
                        "Settings",
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
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Card(
                elevation: 0.4,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.41,
                  child: Column(
                    children: [
                      Container(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => EditProfile()));
                          },
                          leading: Icon(
                            Icons.person,
                          ),
                          title: Text(
                            "Edit Profile",
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: mycolor,
                              )),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ChangePassword()));
                          },
                          leading: Icon(
                            Icons.settings,
                          ),
                          title: Text(
                            "Change Password",
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: mycolor,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: mycolor)),
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => Sign_in_screen())));
                                LocalStorage().clearPref();
                              },
                              child: Text(
                                "Log out",
                              ))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

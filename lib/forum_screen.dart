import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/provider/app_provider.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:chat_app/widgets/chat_bottombar.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumScreen extends StatefulWidget {
  String username;
  ForumScreen({required this.username});
  //final OurUser recipient;
  //final String chatRoomid;
  //ForumScreen(this.recipient, this.chatRoomid);
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  initState() {
    super.initState();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getForumData();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(height: h * 13.7),
              appProvider.forumData != null
                  ? Expanded(
                      child: ChatMessages(
                          forum: true,
                          data: appProvider.forumData!,
                          username: widget.username))
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator()),
            ],
          ),
          /*ChatAppBar(
            icon: Icons.arrow_back,
          ),*/
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatBottomBar(
              sender: widget.username,
              forum: true,
            ),
          ),
        ],
      ),
    );
  }
}

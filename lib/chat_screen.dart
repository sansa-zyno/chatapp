import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/provider/app_provider.dart';
import 'package:chat_app/widgets/chat_appbar.dart';
import 'package:chat_app/widgets/chat_bottombar.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  String senderName;
  String receiverName;
  String receiverProfilePics;
  ChatScreen(
      {required this.senderName,
      required this.receiverName,
      required this.receiverProfilePics});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  initState() {
    super.initState();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getChatData(widget.senderName, widget.receiverName);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: h * 13.7),
              appProvider.chatData != null
                  ? Expanded(
                      child: ChatMessages(
                      forum: false,
                      data: appProvider.chatData!,
                      username: widget.senderName,
                    ))
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator()),
            ],
          ),
          ChatAppBar(
              icon: Icons.arrow_back,
              senderName: widget.receiverName,
              senderProfilePics: widget.receiverProfilePics),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatBottomBar(
              sender: widget.senderName,
              receiver: widget.receiverName,
              forum: false,
            ),
          ),
        ],
      ),
    );
  }
}

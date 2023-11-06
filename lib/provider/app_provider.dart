import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:chat_app/themes/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/http.service.dart';

class AppProvider extends ChangeNotifier {
  String type = "";
  bool reply = false;
  String senderReplied = "";
  String chatid = "";
  String msgreplied = "";

  List? forumData;
  List? chatData;
  List? notifications;
  List? recentChatData;
  String imageUrl = "";

  AppProvider() {
    getUsername().then((username) {
      RecentChatData(username);
      getImage(username);
    });
  }

  Future<String> getUsername() async {
    String username = await LocalStorage().getString("username");
    return username;
  }

  updateVal(String msg, String typ, bool rep, String sender, String chatId) {
    msgreplied = msg;
    type = typ;
    reply = rep;
    senderReplied = sender;
    chatid = chatId;
    notifyListeners();
  }

  getForumData() async {
    Response response = await HttpService.post(Api.forum, {});
    forumData = jsonDecode(response.data);
    notifyListeners();
    // log(forumData.toString());
  }

  getChatData(String sender, String receiver) async {
    chatData = null;
    notifyListeners();
    Response response = await HttpService.post(
        Api.chat, {"sender": sender, "receiver": receiver});
    chatData = jsonDecode(response.data);
    notifyListeners();
    //log(chatData.toString());
  }

  RecentChatData(String username) async {
    Response response =
        await HttpService.post(Api.recentChats, {"username": username});

    recentChatData = jsonDecode(response.data);
    notifyListeners();
    //log(recentChatData.toString());
  }

  Future getNotifications() async {
    Response response = await HttpService.post(Api.notifications, {});
    notifications = jsonDecode(response.data);
    notifyListeners();
    // log(notifications.toString());
  }

  getImage(String username) async {
    try {
      Response res =
          await HttpService.post(Api.getProfilePics, {"username": username});
      imageUrl = res.data;
    } catch (e) {
      imageUrl = "";
    }
    notifyListeners();
  }
}

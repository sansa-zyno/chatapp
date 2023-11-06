import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/provider/app_provider.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notification_Screen extends StatefulWidget {
  static const route = "notification_screen";

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen> {
  String calcTimesAgo(DateTime dt) {
    Duration dur = DateTime.now().difference(dt);
    print(dur.inHours);
    if (dur.inSeconds < 60) {
      return dur.inSeconds == 1
          ? "${dur.inSeconds} sec ago"
          : "${dur.inSeconds} sec ago";
    }
    if (dur.inMinutes >= 1 && dur.inMinutes < 60) {
      return dur.inMinutes == 1
          ? "${dur.inMinutes} min ago"
          : "${dur.inMinutes} mins ago";
    }
    if (dur.inHours >= 1 && dur.inHours < 60) {
      return dur.inHours == 1
          ? "${dur.inHours} hour ago"
          : "${dur.inHours} hours ago";
    }
    if (dur.inHours > 60) {
      DateTime dateNow =
          DateTime.parse(DateTime.now().toString().substring(0, 10));
      DateTime dte = DateTime.parse(dt.toString().substring(0, 10));
      String date = dateNow.compareTo(dte) == 0
          ? "Today"
          : "${dte.year} ${dte.month} ${dte.day}" ==
                  "${dateNow.year} ${dateNow.month} ${(dateNow.day) - 1}"
              ? "Yesterday"
              : formatDate(dte, [M, ' ', dd, ', ', yyyy]);
      return date;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          iconTheme: IconThemeData(color: Colors.white),
          toolbarHeight: 90,
          flexibleSpace: SafeArea(
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff4B0973),
                border: Border.all(
                  color: Color(0xff4B0973),
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
                        "Notifications",
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
          backgroundColor: Colors.transparent,
        ),
        body: appProvider.recentChatData != null
            ? appProvider.recentChatData!.isEmpty
                ? Container(
                    margin: EdgeInsets.only(left: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/undraw_Notify_re_65on 1.png'),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            "It seems like you don’t have any notifications yet. Check back later.",
                            style: TextStyle(
                                color: Color(0xff242A37),
                                fontFamily: 'SFUIText-Regular',
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: appProvider.recentChatData!.length,
                    itemBuilder: (context, index) {
                      String timesAgo = calcTimesAgo(DateTime.parse(
                          appProvider.recentChatData![index]["Date"]));
                      return GestureDetector(
                        onTap: () async {
                          await HttpService.post(Api.resetRead, {
                            "username": appProvider.recentChatData![index]
                                ["Receiver"],
                            "messageid": appProvider.recentChatData![index]
                                ["Chat Id"],
                            "message": appProvider.recentChatData![index]
                                ["Recent Chats"]
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ChatScreen(
                                        senderName: appProvider
                                            .recentChatData![index]["Receiver"],
                                        receiverName: appProvider
                                            .recentChatData![index]["Sender"],
                                        receiverProfilePics:
                                            appProvider.recentChatData![index]
                                                ["ProfileImage"],
                                      )));
                          appProvider.RecentChatData(
                              appProvider.recentChatData![index]["Receiver"]);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        "https://pboforum.com/office/${appProvider.recentChatData![index]["ProfileImage"]}",
                                        fit: BoxFit.fill,
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appProvider.recentChatData![index]
                                        ["Sender"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: mycolor),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        appProvider.recentChatData![index]
                                                    ["Recent Chats"]
                                                .toString()
                                                .contains("uploads/images/")
                                            ? Opacity(
                                                opacity:
                                                    appProvider.recentChatData![
                                                                    index]
                                                                ["Read"] ==
                                                            "2"
                                                        ? 0.5
                                                        : 1,
                                                child: Image.network(
                                                  "https://pboforum.com/office/${appProvider.recentChatData![index]["Recent Chats"]}",
                                                  height: 50,
                                                  width: 50,
                                                ),
                                              )
                                            : Expanded(
                                                child: Text(
                                                  "${appProvider.recentChatData![index]["Recent Chats"]}",
                                                  style: TextStyle(
                                                      color:
                                                          appProvider.recentChatData![
                                                                          index]
                                                                      [
                                                                      "Read"] ==
                                                                  "2"
                                                              ? Colors.grey
                                                              : Colors.black),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  timesAgo,
                                  style: TextStyle(color: mycolor),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) => Divider(
                      thickness: 5,
                    ),
                  )
            : Center(child: CircularProgressIndicator()));
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/provider/app_provider.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  String username;
  Messages({Key? key, required this.username}) : super(key: key);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List? admins;

  getAdmins() async {
    Response response = await HttpService.post(Api.admins, {});
    admins = jsonDecode(response.data);
    setState(() {});
    log(admins.toString());
  }

  initState() {
    super.initState();
    getAdmins();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        body: Column(
      children: [
        Flexible(
            child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "Admins",
            style: TextStyle(
                fontSize: 18,
                color: Color(0xff4B0973),
                fontWeight: FontWeight.bold),
          ),
        )),
        admins != null
            ? admins!.isNotEmpty
                ? Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: admins!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 15),
                            child: Container(
                              width: 150,
                              height: 90,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  //border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10.0,
                                        offset: Offset(2, 2),
                                        color: Colors.grey.withOpacity(0.5))
                                  ]),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => ChatScreen(
                                                senderName: widget.username,
                                                receiverName: admins![index]
                                                    ["username"],
                                                receiverProfilePics:
                                                    admins![index]
                                                        ["ProfilePicsImage"],
                                              )));
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                                height: 70,
                                                width: 70,
                                                imageUrl:
                                                    "https://pboforum.com/office/${admins![index]["ProfilePicsImage"]}",
                                                fit: BoxFit.fill,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                  value: progress
                                                                      .progress),
                                                        ))),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "${admins![index]["username"]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff4B0973),
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    /*Positioned(
                                      right: 55,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            docs[index]["status"] == "online"
                                                ? Colors.green
                                                : Colors.grey,
                                        radius: 5,
                                      ),
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No admins"),
                      ],
                    ),
                  )
            : Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
        appProvider.recentChatData != null
            ? appProvider.recentChatData!.isNotEmpty
                ? Expanded(
                    flex: 6,
                    child: ListView.separated(
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: appProvider.recentChatData!.length,
                      itemBuilder: (cxt, index) {
                        return ChatRoomListTile(
                            appProvider.recentChatData![index]["Recent Chats"],
                            appProvider.recentChatData![index]["Message Type"],
                            appProvider.recentChatData![index]["Sender"],
                            appProvider.recentChatData![index]["Receiver"],
                            appProvider.recentChatData![index]["ProfileImage"],
                            appProvider.recentChatData![index]["Date"],
                            appProvider.recentChatData![index]["Chat Id"],
                            appProvider.recentChatData![index]['Read'] == "2");
                      },
                      separatorBuilder: (ctx, index) => Divider(
                        thickness: 5,
                      ),
                    ),
                  )
                : Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("No recent messages to show")]),
                  )
            : Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator()]),
              ),
      ],
    ));
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage,
      type,
      senderName,
      receiverName,
      dateString,
      receiverProfileImage,
      chatId;
  final bool read;
  ChatRoomListTile(
      this.lastMessage,
      this.type,
      this.senderName,
      this.receiverName,
      this.receiverProfileImage,
      this.dateString,
      this.chatId,
      this.read);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String timesAgo = "";

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
  void initState() {
    // TODO: implement initState
    super.initState();
    timesAgo = calcTimesAgo(DateTime.parse(widget.dateString));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        await HttpService.post(Api.resetRead, {
          "username": widget.receiverName,
          "messageid": widget.chatId,
          "message": widget.lastMessage
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ChatScreen(
                      senderName: widget.receiverName,
                      receiverName: widget.senderName,
                      receiverProfilePics: widget.receiverProfileImage,
                    )));
        appProvider.RecentChatData(widget.receiverName);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8.0),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      "https://pboforum.com/office/${widget.receiverProfileImage}",
                      fit: BoxFit.fill,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                /* Positioned(
                    top: 0,
                    right: 2,
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red),
                        child: Center(
                            child: Text('5',
                                style: TextStyle(color: Colors.white)))))*/
              ],
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.senderName,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff4B0973),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                widget.type == "message"
                    ? Container(
                        width: 200,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.lastMessage,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                  color:
                                      widget.read ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: widget.read ? 0.5 : 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  "https://pboforum.com/office/${widget.lastMessage}",
                                  height: 60,
                                  width: 60,
                                ),
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
            ))
          ],
        ),
      ),
    );
  }
}

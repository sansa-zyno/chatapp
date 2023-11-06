import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/provider/app_provider.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  // final OurUser recipient;
  //final String chatRoomId;
  bool forum;
  List data;
  String? username;

  ChatMessages(
      // this.recipient,
      //this.chatRoomId,
      {
    required this.forum,
    required this.data,
    this.username,
  });

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  int idx = -1;
  Stream? messageStream;
  ScrollController? scrollController;
  late AppProvider appProvider;

  Widget chatMessageTile(
      String message,
      bool sendByMe,
      String senderName,
      String receiverName,
      String senderPics,
      String receiverPics,
      String reply,
      String time,
      h,
      w) {
    return !sendByMe
        ? message != ""
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                            height: 40,
                            width: 40,
                            imageUrl: receiverPics,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    ))),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            constraints: BoxConstraints(maxWidth: 200),
                            decoration: BoxDecoration(
                              color: Color(0xff4B0973),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                reply != ""
                                    ? reply.contains("uploads/images/")
                                        ? Flexible(
                                            child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 197, 207, 243),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Image.network(
                                                  "https://pboforum.com/office/$reply",
                                                  height: 40,
                                                  width: 40,
                                                )),
                                          )
                                        : Flexible(
                                            child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 197, 207, 243),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Text(
                                                  reply,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: "Nunito"),
                                                )),
                                          )
                                    : Container(
                                        width: 3,
                                      ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  message,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: "Helvetica"),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  time,
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            senderName,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container()
        : message != ""
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 197, 207, 243),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: reply != ""
                                      ? reply.contains("uploads/images/")
                                          ? Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff4B0973),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Image.network(
                                                "https://pboforum.com/office/$reply",
                                                height: 40,
                                                width: 40,
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff4B0973),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Text(
                                                reply,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Nunito",
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )
                                      : Container(
                                          width: 3,
                                        ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  message,
                                  style: TextStyle(
                                      fontSize: 16.0, fontFamily: "Helvetica"),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  time,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            senderName,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                            height: 40,
                            width: 40,
                            imageUrl: senderPics,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    )))
                  ],
                ),
              )
            : Container();
  }

  Widget imageMessageTile(
      String? url,
      bool sendByMe,
      String senderName,
      String receiverName,
      String senderPics,
      String receiverPics,
      String reply,
      String time) {
    return sendByMe
        ? url != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Icon(Icons.phone,color: const Color(0xff7672c9),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          //height: 180,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 197, 207, 243),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              reply != ""
                                  ? reply.contains("uploads/images/")
                                      ? Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color(0xff4B0973),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Image.network(
                                            "https://pboforum.com/office/$reply",
                                            height: 40,
                                            width: 40,
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color(0xff4B0973),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Text(
                                            reply,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Nunito",
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        )
                                  : Container(),
                              SizedBox(
                                height: 8,
                              ),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                child: Image.network(
                                  "https://pboforum.com/office/${url}",
                                  height: 90,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                time,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          senderName,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                            height: 40,
                            width: 40,
                            imageUrl: senderPics,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    )))
                  ],
                ),
              )
            : Container()
        : url != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Icon(Icons.phone,color: const Color(0xff7672c9),),

                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                            height: 40,
                            width: 40,
                            imageUrl: receiverPics,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    ))),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //height: 180,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Color(0xff4B0973),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              reply != ""
                                  ? reply.contains("uploads/images/")
                                      ? Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 197, 207, 243),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Image.network(
                                            "https://pboforum.com/office/$reply",
                                            height: 40,
                                            width: 40,
                                          ))
                                      : Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 197, 207, 243),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Text(
                                            reply,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "Nunito"),
                                          ))
                                  : Container(),
                              SizedBox(
                                height: 8,
                              ),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                child: Image.network(
                                  "https://pboforum.com/office/${url}",
                                  height: 90,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                time,
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          senderName,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container();
  }

  Widget chatMessages(h, w, BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      widget.forum
          ? Future.delayed(Duration(seconds: 3), () async {
              String? savedNotification =
                  await LocalStorage().getString("notification");
              print(savedNotification.toString());
              Map ssavedNotification = savedNotification != null
                  ? jsonDecode(savedNotification)
                  : {};
              log("passed");
              if (appProvider.notifications != null &&
                  appProvider.notifications!.isNotEmpty) {
                if (appProvider.notifications!.first != ssavedNotification) {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Notification",
                                  style: TextStyle(
                                      color: Color(0xff4B0973),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                            insetPadding: EdgeInsets.all(8),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      "https://pboforum.com/office/${appProvider.notifications!.first["NotificationImage"]}",
                                      height: 70,
                                      width: 70,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                      appProvider.notifications!
                                          .first["NotificatioDetails"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          )).then((val) async {
                    print(
                        appProvider.notifications!.first != ssavedNotification);
                    await LocalStorage().setString("notification",
                        appProvider.notifications!.first.toString());
                  });
                }
              }
            })
          : {};

      if (scrollController!.hasClients) {
        scrollController!.animateTo(
          scrollController!.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
    return widget.data.isNotEmpty
        ? ListView.builder(
            itemCount: (widget.data.length + 1),
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(0),
            controller: scrollController,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == widget.data.length) {
                return Container(
                  height: 100,
                );
              }
              bool isSameDate = true;
              DateTime dt = DateTime.parse(
                  widget.data[index]["Date"].toString().substring(0, 10));
              if (index == 0) {
                isSameDate = false;
              } else {
                DateTime dte = DateTime.parse(widget.data[index - 1]["Date"]
                    .toString()
                    .substring(0, 10)); //date of prev item
                isSameDate =
                    dt.compareTo(dte) == 0 ? true : false; //compare dates
              }

              if (index == 0 || !(isSameDate)) {
                DateTime dt = DateTime.parse(
                    widget.data[index]["Date"].toString().substring(0, 10));
                DateTime dtTime = DateTime.parse(widget.data[index]["Date"]);
                String time = formatDate(dtTime, [hh, ':', nn, ' ', am]);
                DateTime dateNow =
                    DateTime.parse(DateTime.now().toString().substring(0, 10));
                String date = dt.compareTo(dateNow) == 0
                    ? "Today"
                    : "${dt.year} ${dt.month} ${dt.day}" ==
                            "${dateNow.year} ${dateNow.month} ${(dateNow.day) - 1}"
                        ? "Yesterday"
                        : formatDate(dt, [M, ' ', dd, ', ', yyyy]);
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        widget.data[index]['Sender'] == widget.username
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          date.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff4B0973),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 8),
                      //ListTile(title: Text('item $index'))
                      widget.data[index]["Message Type"] == 'message'
                          ? InkWell(
                              onTap: () {
                                appProvider.updateVal("", "", false, "", "");
                              },
                              onLongPress: () {
                                idx = index;
                                setState(() {});
                                if (index == idx) {
                                  appProvider.updateVal(
                                      widget.data[index]["Message"],
                                      "text",
                                      true,
                                      widget.data[index]["Sender"],
                                      widget.data[index]["Chat Id"]);
                                }
                              },
                              child: Container(
                                color: index == idx
                                    ? appProvider.reply
                                        ? Colors.blue[100]
                                        : Colors.white
                                    : Colors.white,
                                child: chatMessageTile(
                                  widget.data[index]["Message"],
                                  widget.data[index]['Sender'] ==
                                      widget.username,
                                  widget.data[index]["Sender"],
                                  widget.data[index]["Receiver"],
                                  widget.data[index]["SenderProfileImage"],
                                  widget.data[index]["ReceiverProfileImage"],
                                  widget.data[index]["Replied Message"] ?? "",
                                  time,
                                  h,
                                  w,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                appProvider.updateVal("", "", false, "", "");
                              },
                              onLongPress: () {
                                idx = index;
                                setState(() {});
                                if (index == idx) {
                                  appProvider.updateVal(
                                      widget.data[index]["Message"],
                                      "image",
                                      true,
                                      widget.data[index]["Sender"],
                                      widget.data[index]["Chat Id"]);
                                }
                              },
                              child: Container(
                                color: index == idx
                                    ? appProvider.reply
                                        ? Colors.blue[100]
                                        : Colors.white
                                    : Colors.white,
                                child: imageMessageTile(
                                    widget.data[index]['Message'],
                                    widget.data[index]['Sender'] ==
                                        widget.username,
                                    widget.data[index]["Sender"],
                                    widget.data[index]["Receiver"],
                                    widget.data[index]["SenderProfileImage"],
                                    widget.data[index]["ReceiverProfileImage"],
                                    widget.data[index]["Replied Message"] ?? "",
                                    time),
                              ),
                            )
                    ]);
              } else {
                DateTime dtTime = DateTime.parse(widget.data[index]["Date"]);
                String time = formatDate(dtTime, [hh, ':', nn, ' ', am]);
                return widget.data[index]["Message Type"] == 'message'
                    ? InkWell(
                        onTap: () {
                          appProvider.updateVal("", "", false, "", "");
                        },
                        onLongPress: () {
                          idx = index;
                          setState(() {});
                          if (index == idx) {
                            appProvider.updateVal(
                                widget.data[index]["Message"],
                                "text",
                                true,
                                widget.data[index]["Sender"],
                                widget.data[index]["Chat Id"]);
                          }
                        },
                        child: Container(
                          color: index == idx
                              ? appProvider.reply
                                  ? Colors.blue[100]
                                  : Colors.white
                              : Colors.white,
                          child: chatMessageTile(
                            widget.data[index]["Message"],
                            widget.data[index]['Sender'] == widget.username,
                            widget.data[index]["Sender"],
                            widget.data[index]["Receiver"],
                            widget.data[index]["SenderProfileImage"],
                            widget.data[index]["ReceiverProfileImage"],
                            widget.data[index]["Replied Message"] ?? "",
                            time,
                            h,
                            w,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          appProvider.updateVal("", "", false, "", "");
                        },
                        onLongPress: () {
                          idx = index;
                          setState(() {});
                          if (index == idx) {
                            appProvider.updateVal(
                                widget.data[index]["Message"],
                                "image",
                                true,
                                widget.data[index]["Sender"],
                                widget.data[index]["Chat Id"]);
                          }
                        },
                        child: Container(
                          color: index == idx
                              ? appProvider.reply
                                  ? Colors.blue[100]
                                  : Colors.white
                              : Colors.white,
                          child: imageMessageTile(
                              widget.data[index]['Message'],
                              widget.data[index]['Sender'] == widget.username,
                              widget.data[index]["Sender"],
                              widget.data[index]["Receiver"],
                              widget.data[index]["SenderProfileImage"],
                              widget.data[index]["ReceiverProfileImage"],
                              widget.data[index]["Replied Message"] ?? "",
                              time),
                        ),
                      );
              }
            }, // optional // optional
          )
        : Center(
            child: Text(
            "Start a new chat",
            style: TextStyle(fontSize: 16),
          ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    //messageStream = Database().getChatRoomMessages(widget.chatRoomId);
    appProvider = Provider.of<AppProvider>(context, listen: false);
    Timer.periodic(Duration(milliseconds: 250), (timer) {
      appProvider.getNotifications();
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    appProvider = Provider.of<AppProvider>(context);
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: chatMessages(h, w, context),
        ),
        SizedBox(
          height: 88.2,
        )
      ],
    ));
  }
}

/*const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}*/

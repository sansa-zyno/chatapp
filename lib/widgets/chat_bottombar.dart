import 'dart:developer';
import 'dart:io';
import 'package:chat_app/constants.dart';
import 'package:chat_app/provider/app_provider.dart';
import 'package:chat_app/services/api.dart';
import 'package:chat_app/services/http.service.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatBottomBar extends StatefulWidget {
  final String sender;
  final String? receiver;
  final bool forum;
  ChatBottomBar({required this.sender, this.receiver, required this.forum});

  @override
  _ChatBottomBarState createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  TextEditingController messageTextEdittingController = TextEditingController();
  //PlatformFile? file;
  XFile? image;
  late AppProvider appProvider;

  addMessage(context) async {
    appProvider = Provider.of<AppProvider>(context, listen: false);

    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;
      var uuid = Uuid();
      Response response = await HttpService.post(
          Api.addMessage,
          appProvider.reply
              ? {
                  "sender": widget.sender,
                  "receiver": widget.receiver,
                  "message": message,
                  "reply": appProvider.msgreplied,
                  "replyid": appProvider.chatid,
                  "rsend": appProvider.senderReplied
                }
              : {
                  "sender": widget.sender,
                  "receiver": widget.receiver,
                  "message": message
                });
      if (response.statusCode == 200) {
        messageTextEdittingController.text = "";
        appProvider.getChatData(widget.sender, widget.receiver!);
      }
      log("response" + response.data.toString());
    }
  }

  addMessageToGroup(context) async {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    log(appProvider.reply.toString());

    if (messageTextEdittingController.text != "") {
      var uuid = Uuid();
      String message = messageTextEdittingController.text;
      Response response = await HttpService.post(
          Api.addMessageToGroup,
          appProvider.reply
              ? {
                  "sender": widget.sender,
                  "message": message,
                  "reply": appProvider.msgreplied,
                  "replyid": appProvider.chatid,
                  "rsend": appProvider.senderReplied
                }
              : {"sender": widget.sender, "message": message});
      if (response.statusCode == 200) {
        messageTextEdittingController.text = "";
        appProvider.getForumData();
      }
      log(response.data.toString());
    }
  }

  addFile() async {
    //FilePickerResult? result = await FilePicker.platform.pickFiles();
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    appProvider = Provider.of<AppProvider>(context, listen: false);
    if (image != null) {
      //file = result.files.single;
      var uuid = Uuid();
      Response response = await HttpService.postWithFiles(
          Api.addImage,
          appProvider.reply
              ? {
                  "sender": widget.sender,
                  "receiver": widget.receiver,
                  "file": MultipartFile.fromBytes(
                      File(image!.path).readAsBytesSync(),
                      filename: image!.name),
                  "reply": appProvider.msgreplied,
                  "replyid": appProvider.chatid,
                  "rsend": appProvider.senderReplied
                }
              : {
                  "sender": widget.sender,
                  "receiver": widget.receiver,
                  "file": MultipartFile.fromBytes(
                      File(image!.path).readAsBytesSync(),
                      filename: image!.name),
                });
      if (response.statusCode == 200) {
        appProvider.getChatData(widget.sender, widget.receiver!);
      }
      log(response.data.toString());
    }
  }

  addFileToGroup() async {
    //FilePickerResult? result = await FilePicker.platform.pickFiles();
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    appProvider = Provider.of<AppProvider>(context, listen: false);
    if (image != null) {
      //file = result.files.single;
      var uuid = Uuid();
      Response response = await HttpService.postWithFiles(
          Api.addImageToGroup,
          appProvider.reply
              ? {
                  "sender": widget.sender,
                  "file": MultipartFile.fromBytes(
                      File(image!.path).readAsBytesSync(),
                      filename: image!.name),
                  "reply": appProvider.msgreplied,
                  "replyid": appProvider.chatid,
                  "rsend": appProvider.senderReplied
                }
              : {
                  "sender": widget.sender,
                  "file": MultipartFile.fromBytes(
                      File(image!.path).readAsBytesSync(),
                      filename: image!.name),
                });
      if (response.statusCode == 200) {
        appProvider.getForumData();
      }
      log(response.data.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    appProvider = Provider.of<AppProvider>(context);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: 8),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 10.0,
              offset: Offset(2, 2),
              color: Colors.grey.withOpacity(0.5))
        ]),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              appProvider.type == ""
                  ? Container()
                  : appProvider.type == "text"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appProvider.senderReplied == widget.sender
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "You",
                                        style:
                                            TextStyle(color: Color(0xff4B0973)),
                                      ),
                                      InkWell(
                                        child: Icon(Icons.cancel,
                                            color: Color(0xff4B0973)),
                                        onTap: () {
                                          appProvider.updateVal(
                                              "", "", false, "", "");
                                        },
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        appProvider.senderReplied,
                                        style:
                                            TextStyle(color: Color(0xff4B0973)),
                                      ),
                                      InkWell(
                                        child: Icon(Icons.cancel,
                                            color: Color(0xff4B0973)),
                                        onTap: () {
                                          appProvider.updateVal(
                                              "", "", false, "", "");
                                        },
                                      )
                                    ],
                                  ),
                            Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border(
                                      left: BorderSide(
                                        color: Color(0xff4B0973),
                                        width: 10,
                                      ),
                                    )),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: Text(appProvider.msgreplied)),
                                  ],
                                )),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appProvider.senderReplied == widget.sender
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "You",
                                        style:
                                            TextStyle(color: Color(0xff4B0973)),
                                      ),
                                      InkWell(
                                        child: Icon(Icons.cancel,
                                            color: Color(0xff4B0973)),
                                        onTap: () {
                                          appProvider.updateVal(
                                              "", "", false, "", "");
                                        },
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        appProvider.senderReplied,
                                        style:
                                            TextStyle(color: Color(0xff4B0973)),
                                      ),
                                      InkWell(
                                        child: Icon(Icons.cancel,
                                            color: Color(0xff4B0973)),
                                        onTap: () {
                                          appProvider.updateVal(
                                              "", "", false, "", "");
                                        },
                                      )
                                    ],
                                  ),
                            Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xff4B0973),
                                      width: 10,
                                    ),
                                  )),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Image.network(
                                      "https://pboforum.com/office/${appProvider.msgreplied}",
                                      height: 90,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextEdittingController,
                      decoration: InputDecoration(
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mycolor, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        fillColor: Colors.white60,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        hintText: 'Type a message...',
                        suffixIcon: IconButton(
                          onPressed: () {
                            widget.forum
                                ? addMessageToGroup(context)
                                : addMessage(context);
                            appProvider.updateVal("", "", false, "", "");
                          },
                          icon: Icon(
                            Icons.send_rounded,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.forum ? addFileToGroup() : addFile();
                      appProvider.updateVal("", "", false, "", "");
                    },
                    icon: Icon(
                      Icons.attachment_rounded,
                      color: Color(0xff4B0973),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

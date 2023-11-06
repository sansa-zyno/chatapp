import 'package:chat_app/forum_screen.dart';
import 'package:chat_app/messages_screen.dart';
import 'package:chat_app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  String username;
  Home({Key? key, required this.username}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: Container(),
            toolbarHeight: 90,
            flexibleSpace: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff4B0973),
                border: Border.all(
                  color: Color(0xff4B0973),
                  width: 1,
                ),
              ),
              child: TabBar(
                //indicatorColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child: Row(children: [
                      Text("Recent chats", style: TextStyle(fontSize: 16)),
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: appProvider.recentChatData != null
                            ? Text(
                                "${appProvider.recentChatData!.length}",
                                style: TextStyle(color: Color(0xff4B0973)),
                              )
                            : Container(),
                      )
                    ]),
                  ),
                  Tab(
                    child: Row(children: [
                      Text("Forum", style: TextStyle(fontSize: 16))
                    ]),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(children: [
            Messages(username: widget.username),
            ForumScreen(username: widget.username)
          ]),
        ));
  }
}

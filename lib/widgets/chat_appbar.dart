import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  //final OurUser recipient;
  final IconData icon;
  String senderName;
  String senderProfilePics;

  ChatAppBar(
      {
      //required this.recipient,
      required this.icon,
      required this.senderName,
      required this.senderProfilePics});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff4B0973),
          border: Border.all(
            color: Color(0xff4B0973),
            width: w * 0.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
            ),
            /*Expanded(
              child: GestureDetector(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 1.9, vertical: h * 0.8),
                    child: Icon(icon, color: Color(0xff00AEFF), size: w * 7.3),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),*/
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                            height: 70,
                            width: 70,
                            imageUrl:
                                "https://pboforum.com/office/$senderProfilePics",
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    ))),
                    SizedBox(width: w * 3.6),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: w * 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              senderName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 4.8,
                              ),
                            ),
                          ),

                          /*Flexible(
                            child: Text(
                              "Online",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 4.8,
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

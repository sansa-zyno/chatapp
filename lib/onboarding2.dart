import 'package:chat_app/onboarding3.dart';
import 'package:chat_app/widgets/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';

class OnBoarding2 extends StatefulWidget {
  OnBoarding2({
    Key? key,
  }) : super(key: key);

  @override
  State<OnBoarding2> createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Image.asset(
                'images/pbo1.jpeg',
                height: 200,
                width: 500,
                fit: BoxFit.fill,
              ),
            ),
            Spacer(),
            Text(
              "OUR MISSION",
              style: TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 7, 38, 95),
                  fontWeight: FontWeight.bold,
                  fontFamily: "poppins"),
            ),
            SizedBox(height: 15),
            Text(
              "To discover affordable lands in fast developing areas and make these known to you and also show you how you can make money to buy land and build your own house or buy a house of your own.",
              style: TextStyle(fontSize: 14, fontFamily: "poppins"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            Container(
              width: 250,
              height: 50,
              child: Hero(
                tag: "Login",
                child: GradientButton(
                  title: "Next",
                  clrs: [
                    Color.fromARGB(255, 7, 38, 95),
                    Color.fromARGB(255, 7, 38, 95)
                  ],
                  onpressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: OnBoarding3()),
                    );
                  },
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

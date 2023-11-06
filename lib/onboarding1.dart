import 'package:chat_app/onboarding2.dart';
import 'package:chat_app/widgets/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class OnBoarding1 extends StatefulWidget {
  OnBoarding1({Key? key}) : super(key: key);

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  //border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10.0,
                        offset: Offset(2, 2),
                        color: Colors.grey.withOpacity(0.3))
                  ]),
              child: Image.asset(
                'images/pbo01.jpeg',
                height: 200,
                width: 500,
                fit: BoxFit.fill,
              ),
            ),
            Spacer(),
            Text(
              "OUR VISION",
              style: TextStyle(
                  color: Color.fromARGB(255, 7, 38, 95),
                  fontSize: 22,
                  fontFamily: "poppins",
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              "Making Home Ownership Dream a Reality…",
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
                          child: OnBoarding2()),
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

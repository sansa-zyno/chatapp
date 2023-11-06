import 'package:chat_app/login.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:chat_app/widgets/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';

class OnBoarding3 extends StatefulWidget {
  OnBoarding3({Key? key}) : super(key: key);

  @override
  State<OnBoarding3> createState() => _OnBoarding3State();
}

class _OnBoarding3State extends State<OnBoarding3> {
  onboardingShown() async {
    await LocalStorage().setBool("onboarded", true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    onboardingShown();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Image.asset(
                'images/pbo2.jpeg',
                height: 200,
                width: 500,
                fit: BoxFit.fill,
              ),
            ),
            Spacer(),
            Text(
              "OUR CORE VALUES",
              style: TextStyle(
                  color: Color.fromARGB(255, 7, 38, 95),
                  fontSize: 22,
                  fontFamily: "poppins",
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "poppins",
                    ),
                    children: [
                  TextSpan(text: "A – Accountability\n\n"),
                  TextSpan(text: "R – Responsibility\n\n"),
                  TextSpan(text: "I – Integrity\n\n"),
                  TextSpan(text: "S – Service\n\n"),
                  TextSpan(text: "E – Excellence")
                ])),
            SizedBox(height: 100),
            Container(
              width: 250,
              height: 50,
              child: Hero(
                tag: "Login",
                child: GradientButton(
                  title: "Proceed",
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
                          child: Sign_in_screen()),
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

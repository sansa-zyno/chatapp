import 'package:chat_app/login.dart';
import 'package:chat_app/onboarding1.dart';
import 'package:chat_app/provider/app_provider.dart';
import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/services/local_storage.dart';
import 'package:chat_app/user_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterStatusbarcolor.setStatusBarColor(Color(0xff4B0973));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String? username;
  bool? onboaded;
  bool loading = false;

  getUserData() async {
    loading = true;
    setState(() {});
    username = await LocalStorage().getString("username");
    try {
      onboaded = await LocalStorage().getBool("onboarded");
    } catch (e) {
      onboaded = false;
    }
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
        builder: (context, child) => GetMaterialApp(
            theme: Provider.of<ThemeProvider>(context).themeData,
            debugShowCheckedModeBanner: false,
            home: loading
                ? Scaffold(
                    body: Center(
                        child: SpinKitFadingCircle(
                    color: Color(0xFF072A6C),
                  )))
                : username != null
                    ? UserNavigation(username: username!)
                    : onboaded == true
                        ? Sign_in_screen()
                        : OnBoarding1()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vn_travel_app/features/login/login_view.dart';
import 'package:flutter/services.dart';
import 'package:vn_travel_app/features/splash/splash_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(0xff0C3040)));
    return MaterialApp(
      title: 'Ứng dụng du lịch Việt Nam',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Login(true),
        '/splash': (context) => SplashPage(),
      },
    );
  }
}

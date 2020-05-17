import 'package:flutter/material.dart';
import 'package:vn_travel_app/features/login/login_view.dart';
import 'dart:io';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashPageState();
  }
//  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
//  InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    loadAds();
  }

  void loadAds () async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("conect");
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Login(true)));
      }
    } on SocketException catch (_) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Login(true)));
    }
  }

//  @override
//  void dispose() {
//    _interstitialAd?.dispose();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Color(0xffF53361),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/splash.png"), fit: BoxFit.cover),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }

}
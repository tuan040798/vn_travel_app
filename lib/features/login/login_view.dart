import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vn_travel_app/features/routers.dart';
import 'package:vn_travel_app/utils/rest_api/login_api.dart';
import 'dart:io';
import 'dart:async';

class Login extends StatefulWidget {

  bool autoLogin = true;

  Login(this.autoLogin);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/plus.login',
  ],);
  final facebookLogin = FacebookLogin();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  String email;
  bool isLoading = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    if(widget.autoLogin){
      //isSignedIn();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  void loadingTimeOut () {
    this.setState(() {
      isLoading = false;
    });
    Fluttertoast.showToast(msg: "Connection Failed");
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });
    var timer;
    try {
      timer = Timer(Duration(seconds: 7), () => loadingTimeOut);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try {
          isLoggedIn = await facebookLogin.isLoggedIn;

          if(!isLoggedIn) {
            isLoggedIn = await googleSignIn.isSignedIn();
            GoogleSignInAccount googleUser = await googleSignIn.signIn();
            GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            await autoLogin("Google", googleAuth.accessToken);
          } else {
            final result = await facebookLogin.logIn(['email', 'public_profile']);
            await autoLogin("Facebook", result.accessToken.token);
          }
        } catch(_){
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Sign in fail");
        }
      }
    } on SocketException catch (_) {
      timer.cancel();
      print('not connected');
      this.setState(() {
        isLoading = false;
      });
    }

    this.setState(() {
      isLoading = false;
    });


    if (isLoggedIn) {
      timer.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Router()),
      );
    }

  }


  Future<Null> _loginWithGoogle() async {
    this.setState(() {
      isLoading = true;
    });
    var timer;
//    FirebaseUser firebaseUser;
    try {
      timer = Timer(Duration(seconds: 7), () => loadingTimeOut);
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      print("oke: ${googleUser.displayName}");
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      var check = await postAuthGG(googleAuth.accessToken);

      print("Check: $check");

      if (check) {
        timer.cancel();
        this.setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "Sign in success");

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Router()),
        );
      } else {
        timer.cancel();
        this.setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Sign in fail");
      }

    } catch(e) {
      timer.cancel();
      this.setState(() {
        isLoading = false;
      });
    }


  }

  Future<Null> _loginWithFaceBook() async {
    this.setState(() {
      isLoading = true;
    });
    var timer = Timer(Duration(seconds: 7), () => loadingTimeOut);

    final result = await facebookLogin
        .logIn(['email', 'public_profile']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken myToken = result.accessToken;
      var check = await postAuthFB(myToken.token);

      try{
//        AuthCredential credential =
//        FacebookAuthProvider.getCredential(accessToken: myToken.token);

//        FirebaseUser firebaseUser =
//        await firebaseAuth.signInWithCredential(credential).catchError((onError){
//          Fluttertoast.showToast(msg: "This Email is already taken");
//        });
//        print("Check: $check ----- User: ${firebaseUser.displayName}");
        if (check) {
          timer.cancel();
          this.setState(() {
            isLoading = false;
          });

          Fluttertoast.showToast(msg: "Sign in success");

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Router()),
          );

        } else {
          timer.cancel();
          this.setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Sign in fail");
        }
      }catch(PlatformException){
        timer.cancel();
        this.setState(() {
          isLoading = false;
        });
      }
    } else {
      timer.cancel();
      this.setState(() {
        isLoading = false;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
        backgroundColor: Color(0xff0C3040),
        body: new Stack(
          children: <Widget>[
            new ListView(
              children: <Widget>[
                new Stack(
                  children: <Widget>[
                    new Container(
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: new Image.asset(
                                  "assets/images/Welcometo.png",
                                  width: width / 3,
                                )),
                            new Text('Ứng dụng du lịch Việt Nam',
                                style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child: new Center(
                                child: new Stack(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      child: new Image.asset(
                                        "assets/images/btsLogin.png",
                                        width: width / 1.7,
                                        height: width / 1.7,
                                      ),
                                    ),
                                    Container(
                                      child: new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Container(
                                            child: Image.asset(
                                              "assets/images/oval.png",
                                              width: width / 7,
                                              height: width / 7,
                                            ),
                                          ),
                                          Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Comfortaa',),
                            ),
                            SizedBox(height: 30,),
//                            Padding(
//                              padding: const EdgeInsets.only(top: 15),
//                              child: new Container(
//                                width: width*8/10,
//                                height: (width* 8/10)*160/988,
//                                decoration: new BoxDecoration(
//                                  image: new DecorationImage(
//                                    image:
//                                    new AssetImage("assets/images/khungemail.png"),
//                                    fit: BoxFit.cover,
//                                  ),
//                                ),
//                                padding: const EdgeInsets.only(left: 13, top: 13),
//
//                                child: new TextField(
//                                  style: TextStyle(
//                                    fontSize: 18, color: Colors.white54,fontFamily: 'Comfortaa',),
//                                  textAlign: TextAlign.left,
//                                  decoration: new InputDecoration.collapsed(
//                                      hintText: 'Enter your email here',
//                                      hintStyle: TextStyle(
//                                          fontSize: 18, color: Colors.white54 , fontFamily: 'Comfortaa')),
//                                  onChanged: (text) {
//                                    setState(() {
//                                      this.email = text;
//                                    });
//                                  },
//                                ),
//                              ),
//                            ),
//                            Padding(
//                                padding: const EdgeInsets.only(top: 5),
//                                child: new FlatButton(
//                                  onPressed: (){
//
//                                  },
//                                  child: new Container(
//                                    width: width*8/10,
//                                    height: ( width*8/10)*192/ 1020,
//                                    decoration: new BoxDecoration(
//                                      image: new DecorationImage(
//                                        image:
//                                        new AssetImage("assets/images/go.png"),
//                                        fit: BoxFit.cover,
//                                      ),
//                                    ),
//                                    padding: const EdgeInsets.only(top: 13),
//                                    child: new Text(
//                                      "GO",
//                                      textAlign: TextAlign.center,
//                                      style: TextStyle(
//                                        color: Colors.white, fontSize: 20, fontFamily: 'Comfortaa',),
//                                    ),
//                                  ),
//                                )),
//                            Padding(
//                              padding: const EdgeInsets.all(5.0),
//                              child: new Text(
//                                "or sign by",
//                                style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa',),
//                              ),
//                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: new FlatButton(
                                onPressed: _loginWithFaceBook,
                                child: new Container(
                                  width: width*8/10,
                                  height: ( width*8/10)*192/ 1020,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new AssetImage(
                                          "assets/images/khungFB.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: new Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 35.0, top: 15.0),
                                        child: new Image.asset(
                                          "assets/images/fbIcon.png",
                                          alignment: Alignment.centerLeft,
                                          width: width / 10,
                                          height: width / 18,
                                        ),
                                      ),
                                      Center(
                                        child: new Text(
                                          "Facebook",
                                          style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa',),
                                        ),
                                      ),
                                      Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: new FlatButton(
                                  onPressed: _loginWithGoogle,
                                  child: new Container(
                                    width: width*8/10,
                                    height: ( width*8/10)*192/ 1020,
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: new AssetImage(
                                            "assets/images/khungGG.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: new Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 15.0, left: 25.0),
                                          child: new Image.asset(
                                              "assets/images/ggIcon.png",
                                              width: width / 10,
                                              height: width / 18),
                                        ),
                                        Center(
                                          child: new Text(
                                            "Google",
                                            style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa',),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            alignment: Alignment.topRight,
                            child: new Image.asset(
                              "assets/images/ovalCopy.png",
                              width: width / 5.6,
                            ),
                          )
                        ],
                        //
                      ),
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              child: isLoading
                  ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                color: Colors.white.withOpacity(0.8),
              )
                  : Container(),
            ),
          ],
        )
    );
  }
}

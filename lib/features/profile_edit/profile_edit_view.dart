import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:flutter_native_image/flutter_native_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:vn_travel_app/features/login/login_view.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';
import 'package:vn_travel_app/model/user_login.dart';
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
class EditProfileScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfileScreen> {

  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerAbout = new TextEditingController();
  String newName = "";
  String newAboutMe;
  bool imageChoose = false;
  File images;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newAboutMe = user_store.currentUser.aboutMe == null
        ? ""
        : user_store.currentUser.aboutMe;
    setState(() {
      _controllerName.text = user_store.currentUser.name;
      _controllerAbout.text = user_store.currentUser.aboutMe;
    });
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    bool fb = await facebookLogin.isLoggedIn;
    bool gg = await googleSignIn.isSignedIn();

    if (fb) {
      await facebookLogin.logOut();
    }

    if (gg) {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
    }

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login(false)),
            (Route<dynamic> route) => false);

    post_store.refreshStore();
    user_store.refreshUser();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isLoading = true;
      });
      if (user_store.currentUser.id != null) {
        ImageProperties properties =
        await FlutterNativeImage.getImageProperties(image.path);
        File compressedFileFull;
        if (properties.width <= 1300 && properties.height <= 1300) {
          compressedFileFull = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: (properties.width / 1.2).round(),
              targetHeight: (properties.height / 1.2).round());
        } else if (properties.width <= 2400 && properties.height <= 2400) {
          compressedFileFull = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: (properties.width / 3).round(),
              targetHeight: (properties.height *
                  (properties.width / 3) /
                  properties.width)
                  .round());
        } else {
          compressedFileFull = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: (properties.width / 4).round(),
              targetHeight: (properties.height *
                  (properties.width / 4) /
                  properties.width)
                  .round());
        }
        setState(() {
          images = compressedFileFull;
        });
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void _showFullImage(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
              child: new AppBar(
                backgroundColor: Colors.black,
                leading: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    )),
              ),
              preferredSize: Size.fromHeight(45.0)),
          body: Container(
            child: PhotoView(
              imageProvider: NetworkImage(user_store.currentUser.picture),
            ),
          ),
        ),
      ),
    );
  }

  Future saveUserInformation() async {
    setState(() {
      isLoading = true;
    });
    User us = user_store.currentUser;
    if (images != null) {
      await uploadAvatar(user_store.token, images, (String urls) async {
        us.picture = "${server_url}/${urls}";
      });
    }
    if (newName != "") {
      us.name = newName;
    }
    if (newAboutMe != "") {
      us.aboutMe = newAboutMe;
    }
    await user_store.setCurrentUser(us);
    await updateUserById(
        user_store.currentUser, user_store.token, user_store.currentUser.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            "Edit",
            style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
          ),
          leading: new FlatButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              )),
        ),
        body: SafeArea(
            child: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    SafeArea(
                      child: new Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              new Container(
                                  width: width / 3,
                                  height: width / 3,
                                  margin: const EdgeInsets.only(
                                      top: 15.0, bottom: 25.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showFullImage(context);
                                    },
                                    child: Material(
                                      child: Observer(
                                          builder: (_) => images == null
                                              ?(user_store
                                              .currentUser.picture==null?Image.asset("assets/images/avatar.png"):CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                                  child:
                                                  CircularProgressIndicator(
                                                    strokeWidth: 1.0,
                                                    valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                        Colors.blue),
                                                  ),
                                                  width: width / 7,
                                                  height: width / 7,
                                                ),
                                            imageUrl: user_store
                                                .currentUser.picture,
                                            width: width / 3,
                                            height: width / 3,
                                            fit: BoxFit.cover,
                                          )) 
                                              : Container(
                                            width: width / 3,
                                            height: width / 3,
                                            child: Image.file(
                                              images,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(width / 6),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                  )),
                              Container(
                                margin:
                                EdgeInsets.only(left: width / 4.5, top: 10.0),
                                width: 30.0,
                                height: 30.0,
                                child: FlatButton(
                                  onPressed: getImage,
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  padding: EdgeInsets.all(0.0),
                                  child: Image.asset("assets/images/edit.png"),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 10.0),
                            padding: EdgeInsets.only(
                              left: 15.0,
                            ),
                            width: width,
                            height: (width) * 170 / 720,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[350],
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                    1.0,
                                    1.0,
                                  ),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Comfortaa',
                                        fontSize: 13.0),
                                  ),
                                ),
                                Container(
                                  child: new TextField(
                                    controller: _controllerName,
                                    decoration: new InputDecoration(
                                      hintText: "Enter Your Name",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Comfortaa',
                                          fontSize: 16.0),
                                      //contentPadding: new EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    onChanged: (text) {
                                      setState(() {
                                        newName = text;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
//                          Container(
//                            margin:
//                            EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
//                            padding: EdgeInsets.only(
//                              left: 15.0,
//                            ),
//                            width: width,
//                            height: (width) * 170 / 720,
//                            decoration: new BoxDecoration(
//                              color: Colors.white,
//                              border: Border.all(
//                                color: Colors.white,
//                              ),
//                              borderRadius: BorderRadius.all(
//                                Radius.circular(10.0),
//                              ),
//                              boxShadow: [
//                                BoxShadow(
//                                  color: Colors.grey[350],
//                                  blurRadius: 1.0,
//                                  spreadRadius: 1.0,
//                                  offset: Offset(
//                                    1.0,
//                                    1.0,
//                                  ),
//                                )
//                              ],
//                            ),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.spaceAround,
//                              children: <Widget>[
//                                Container(
//                                  margin: EdgeInsets.only(top: 10.0),
//                                  child: Text(
//                                    "User name",
//                                    style: TextStyle(
//                                        color: Colors.black54,
//                                        fontFamily: 'Comfortaa',
//                                        fontSize: 13.0),
//                                  ),
//                                ),
//                                Container(
//                                  child: new TextField(
//                                    decoration: new InputDecoration(
//                                      hintText: "Selena",
//                                      hintStyle: TextStyle(
//                                          color: Colors.black,
//                                          fontFamily: 'Comfortaa',
//                                          fontSize: 16.0),
//                                      //contentPadding: new EdgeInsets.all(10),
//                                      border: InputBorder.none,
//                                    ),
//                                    keyboardType: TextInputType.text,
//                                    autocorrect: false,
//                                    onChanged: (text) {
//                                      // code here
//                                    },
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            padding: EdgeInsets.only(
                              left: 15.0,
                            ),
                            width: width,
                            height: (width) * 170 / 720,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[350],
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                    1.0,
                                    1.0,
                                  ),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "About (${newAboutMe.length}/100)",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Comfortaa',
                                        fontSize: 13.0),
                                  ),
                                ),
                                Container(
                                  child: new TextField(
                                    controller: _controllerAbout,
                                    decoration: new InputDecoration(
                                      hintText: "About Me",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Comfortaa',
                                          fontSize: 16.0),
                                      //contentPadding: new EdgeInsets.all(10),
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    onChanged: (text) {
                                      setState(() {
                                        newAboutMe = text;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height / 11),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: FlatButton(
                                    onPressed: saveUserInformation,
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: width * 7 / 10,
                                      height: (width * 7 / 10) * 192 / 1020,
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage(
                                              "assets/images/khungSave.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Comfortaa',
                                            fontSize: 13.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child: FlatButton(
                                    onPressed: handleSignOut,
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: width * 7 / 10,
                                      height: (width * 7 / 10) * 192 / 1020,
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage(
                                              "assets/images/khungSignOut.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Text(
                                        "Sign out",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Comfortaa',
                                            fontSize: 13.0),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: isLoading
                      ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue)),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                      : Container(),
                )
              ],
            )));
  }
}

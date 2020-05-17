import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;
import 'package:vn_travel_app/features/routers.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
class AllItems {
  String avatar;
  String name;
  bool isChoosed;

  AllItems({this.avatar, this.name, this.isChoosed});

  AllItems.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    name = json['name'];
    isChoosed = json['isChoosed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['isChoosed'] = this.isChoosed;
    return data;
  }
}

class AllAccount extends StatefulWidget {
  final void Function(int) callback;
  final List<AllItems> listAccount;

  AllAccount({Key key, this.callback, @required this.listAccount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AllAccountState(callback: callback, listAccount: this.listAccount);
  }
}

class AllAccountState extends State<AllAccount> {
  final void Function(int) callback;
  final List<AllItems> listAccount;

  AllAccountState({Key key, this.callback, @required this.listAccount});

  Widget _buildAccountItem(BuildContext context, int index) {
    // print("-------------------" +)
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return new Container(
      color: this.listAccount[index].isChoosed
          ? Color(0xfFF002B)
          : Colors.transparent,
      child: FlatButton(
        padding: const EdgeInsets.only(bottom: 7.0, left: 10.0, top: 7.0),
        highlightColor: Color(0xfFF002B),
        splashColor: Colors.transparent,
        onPressed: () {
          callback(index);
        },
        child: Row(
          children: <Widget>[
            Container(
              width: width / 7,
              height: width / 7,
              margin: const EdgeInsets.only(right: 15.0),
              child: Icon(listAccount[index].isChoosed ? Icons.check_box : Icons.check_box_outline_blank),
//              decoration: new BoxDecoration(
//                borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                shape: BoxShape.rectangle,
//                image: new DecorationImage(
//                  fit: BoxFit.fill,
//                  image: new AssetImage(listAccount[index].avatar),
//                ),
//              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  listAccount[index].name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: new ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: _buildAccountItem,
        itemCount: listAccount.length,
      ),
    );
  }
}

// Notification
class ChooseBoardScreen extends StatefulWidget {
  final File image;
  final String title;
  final String description;
  Function callback;
  ChooseBoardScreen(
      {Key key,
      @required this.image,
      @required this.title,
      @required this.description,
      this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChooseBoardState(
        image: image,
        title: title,
        description: description,);
  }
}

class ChooseBoardState extends State<ChooseBoardScreen> {
  final String currentUserId;
  final File image;
  final String title;
  final String description;
  String imageUrl = "";
  bool isLoading = false;
  String thumbUrl;
  String fullUrl;
  Post newPost = new Post();

  void abc() {}

  List<AllItems> _listAccount = [
    new AllItems(
        name: "Reviews",
//        avatar: "assets/images/bts7.png",
        isChoosed: false),
    new AllItems(
        name: "Question",
//        avatar: "assets/images/bts5.png",
        isChoosed: false),
    new AllItems(
        name: "Share",
//        avatar: "assets/images/bts4.png",
        isChoosed: false),
    new AllItems(
        name: "Relax",
//        avatar: "assets/images/bts11.png",
        isChoosed: false),
    new AllItems(
        name: "Tips",
//        avatar: "assets/images/bts13.png",
        isChoosed: false),
    new AllItems(
        name: "Disscusion",
//        avatar: "assets/images/bts12.png",
        isChoosed: false),
    new AllItems(
        name: "News",
//        avatar: "assets/images/bts3.png",
        isChoosed: false),
//    new AllItems(
//        name: "Ads",
////        avatar: "assets/images/bts3.png",
//        isChoosed: false),
  ];

  ChooseBoardState(
      {Key key,
      @required this.image,
      @required this.title,
      @required this.description,
      @required this.currentUserId});

  choosed_board(int index) {
    setState(() {
      this._listAccount[index].isChoosed = !this._listAccount[index].isChoosed;
    });
  }

//  void pushNotifications()async{
//
//    const AndroidNotificationChannel channel = const AndroidNotificationChannel(
//        id: 'default_notification',
//        name: 'Default',
//        description: 'Grant this app the ability to show notifications',
//        importance: AndroidNotificationChannelImportance.HIGH
//    );
//
//
//    await LocalNotifications.createAndroidNotificationChannel(channel: channel);
//
//
//    await LocalNotifications.createNotification(
//        title: "Basic",
//        content: "Notification",
//        id: 0,
//        androidSettings: new AndroidSettings(
//            channel: channel
//        )
//    );
//  }
  Future _post() async {



      var listChoosed = _listAccount.map((e) {
        if (e.isChoosed) {
          return e.name;
        }
      }).toList();
      listChoosed.removeWhere((item) => item == null);
      if (listChoosed.length > 0) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => new Router()),
                (Route<dynamic> route) => false);
        var list = listChoosed.join(",");
        String os = "";
        if (Platform.isAndroid) {
          os = "android";
        } else if (Platform.isIOS) {
          os = "ios";
        }

        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(image.path);
//      print("Image: Width-${properties.width} Height:-${properties.height}");
        File compressedFileThumb;
        File compressedFileFull;
        if (properties.width <= 1300 && properties.height <= 1300) {
          compressedFileThumb = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: (properties.width / 1.2).round(),
              targetHeight: (properties.height / 1.2).round());

          compressedFileFull = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: properties.width,
              targetHeight: properties.height);
        } else if (properties.width <= 2400 && properties.height <= 2400) {
          compressedFileThumb = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: (properties.width / 3).round(),
              targetHeight: (properties.height *
                      (properties.width / 3) /
                      properties.width)
                  .round());

          compressedFileFull = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: (properties.width / 1.5).round(),
              targetHeight: (properties.height *
                      (properties.width / 1.5) /
                      properties.width)
                  .round());
        } else {
          compressedFileThumb = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: (properties.width / 4).round(),
              targetHeight: (properties.height *
                      (properties.width / 4) /
                      properties.width)
                  .round());

          compressedFileFull = await FlutterNativeImage.compressImage(
              image.path,
              quality: 80,
              targetWidth: (properties.width / 2).round(),
              targetHeight: (properties.height *
                      (properties.width / 2) /
                      properties.width)
                  .round());
        }


        await uploadFileFull(user_store.token, compressedFileFull,
            (String url) async {
          await uploadFileThumb(
              user_store.token, compressedFileThumb, setThumbUrl);

//        newPost.author=Author(id: user_store.currentUser.id);



              //Your state change code goes here
              fullUrl = url;
              newPost.fullUrl = "$url";
              newPost.description = description;
              newPost.client = os;
              newPost.title = title;
              newPost.tag = list;

          var responseBody =
          await insertPost(newPost, user_store.token);
          if(responseBody != null) {
            Post postRes= Post.fromJson(responseBody);
            List<Post> listPosted=post_store.posted;
            listPosted.insert(0, postRes);
            await post_store.setPosted(listPosted);

          }
              await post_store.getHomePost();

        });

//        await post_store.getPosted();
        widget.callback;
      } else {

        setState(() {
          this.isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Vui lòng chọn ít nhất một.');
      }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future onSelectNotification(String payload) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }



  void setThumbUrl(String url) async {

        //Your state change code goes here
        thumbUrl = url;
        newPost.thumbUrl = "$url";


  }

//  void setFullUrl(String url,File compressedFileThumb) async {
//    await uploadFileThumb(user_store.token, compressedFileThumb,setThumbUrl);
//    print("Url: $url");
//    setState(() {
//      thumbUrl = url;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      body: SafeArea(
          child: new ListView(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      // search box
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                        ),
                        child: new Row(
                          children: <Widget>[
                            Container(
                              width: 25,
                              height: 25,
                              margin: EdgeInsets.only(right: 10.0),
                              child: FlatButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  padding: EdgeInsets.all(0.0),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 25,
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text("Choose",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Comfortaa'))),
                            ),
                            Container(
                                width: width / 6,
                                height: 30.0,
                                margin: EdgeInsets.only(right: 10.0),
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                                child: FlatButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: _post,
                                  padding: EdgeInsets.all(0.0),
                                  child: Text(
                                    "Post",
                                    style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa'),
                                  ),
                                )),
                          ],
                        ),
                      ),

                      // list account
                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: new AllAccount(
                              callback: choosed_board,
                              listAccount: _listAccount,
                            ),
                          )
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
            ],
          )
      ),
    );
  }
}

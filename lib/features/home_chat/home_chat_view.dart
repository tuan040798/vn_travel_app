import 'package:flutter/material.dart';
import 'package:vn_travel_app/features/private_chat/private_chat_view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:vn_travel_app/features/follow_all/follow_all_view.dart';
import 'package:vn_travel_app/features/other_profile/other_profile.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';

class AvataItems {
  String name;
  String image;

  AvataItems({this.name, this.image});

  AvataItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Avatar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AvatarState();
  }
}

class AvatarState extends State<Avatar> {
  void detail_user(String userid) {
//    if (userid == store.currentUserId) {
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => EditProfileScreen(
//                  currentUserId: userid,
//                )),
//      );
//    } else {
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => OtherProfile(
//                  otherId: userid,
//                )),
//      );
//    }
  }

  Widget _buildAvatarItem(BuildContext context, int index) {
    // print("-------------------" +)
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container();
//    return new Container(
//      width: width / 5.5,
//      margin: const EdgeInsets.only(right: 5.0),
//      child: FlatButton(
//        padding: EdgeInsets.all(0.0),
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//        onPressed: () {
//          //
//        },
//        child: Column(
//          children: <Widget>[
//            Container(
//              width: width / 7,
//              height: width / 7,
//              margin: const EdgeInsets.only(bottom: 5.0),
//              child: GestureDetector(
//                onTap: () {
//                  detail_user(store.users[index].id);
//                },
//                child: Material(
//                  child: CachedNetworkImage(
//                    placeholder: (context, url) => Container(
//                          child: CircularProgressIndicator(
//                            strokeWidth: 1.0,
//                            valueColor:
//                                AlwaysStoppedAnimation<Color>(Colors.blue),
//                          ),
//                          width: width / 7,
//                          height: width / 7,
//                          padding: EdgeInsets.all(15.0),
//                        ),
//                    imageUrl: store.users[index].profilePicture,
//                    width: width / 7,
//                    height: width / 7,
//                    fit: BoxFit.cover,
//                  ),
//                  borderRadius: BorderRadius.all(
//                    Radius.circular(width / 14),
//                  ),
//                  clipBehavior: Clip.hardEdge,
//                ),
//              ),
//            ),
//            Container(
//              child: Text(store.users[index].fullName,
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
//                  style: TextStyle(
//                      color: Colors.black,
//                      fontFamily: 'Comfortaa',
//                      fontSize: 12)),
//            )
//          ],
//        ),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container();
//    return Observer(
//        builder: (_) => store.users.length > 0
//            ? Container(
//                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
//                height: height / 7,
//                child: new ListView.builder(
//                  physics: ScrollPhysics(),
//                  shrinkWrap: true,
//                  scrollDirection: Axis.horizontal,
//                  itemBuilder: _buildAvatarItem,
//                  itemCount: store.users.length,
//                ),
//              )
//            : new Container());
  }
}

// Chat
// final data = [
//   {"avatar":"","name":"","lastSentID":"","lastSentTxt":"","timeShape":"","status":true},
// ];

class ChatItems {
  String avatar;
  String name;
  String lastSentID;
  String lastSentTxt;
  String timeShape;
  bool status;

  ChatItems(
      {this.avatar,
      this.name,
      this.lastSentID,
      this.lastSentTxt,
      this.timeShape,
      this.status});

  ChatItems.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    name = json['name'];
    lastSentID = json['lastSentID'];
    lastSentTxt = json['lastSentTxt'];
    timeShape = json['timeShape'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['lastSentID'] = this.lastSentID;
    data['lastSentTxt'] = this.lastSentTxt;
    data['timeShape'] = this.timeShape;
    data['status'] = this.status;
    return data;
  }
}

class ChatItemsRender extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatItemsState();
  }
}

class ChatItemsState extends State<ChatItemsRender> {

  final List<ChatItems> _chatList = [
    new ChatItems(
        name: 'Jonh',
        avatar: "assets/images/g3.png",
        lastSentID: "You",
        lastSentTxt: "Hello,dshf??",
        timeShape: "22:54",
        status: false),
    new ChatItems(
        name: 'Angelica',
        avatar: "assets/images/b3.png",
        lastSentID: "You",
        lastSentTxt: "Hello,dshf??",
        timeShape: "22:54",
        status: true),
    new ChatItems(
        name: 'Mark',
        avatar: "assets/images/g3.png",
        lastSentID: "You",
        lastSentTxt: "Hello,dshf??",
        timeShape: "22:54",
        status: true),
    new ChatItems(
        name: 'Alice',
        avatar: "assets/images/b3.png",
        lastSentID: "You",
        lastSentTxt: "Hello,dshf??",
        timeShape: "22:54",
        status: false),
    new ChatItems(
        name: 'Love BTS',
        avatar: "assets/images/b3.png",
        lastSentID: "You",
        lastSentTxt: "Hello,dshf??",
        timeShape: "22:54",
        status: true),
    new ChatItems(
        name: 'Alice',
        avatar: "assets/images/g3.png",
        lastSentID: "You",
        lastSentTxt: "Hello,dshf??",
        timeShape: "22:54",
        status: false),
    new ChatItems(
        name: 'Alice',
        avatar: "assets/images/b3.png",
        lastSentID: "You",
        lastSentTxt: "Hello,dshf??",
        timeShape: "22:54",
        status: true),
    new ChatItems(
        name: 'Alice',
        avatar: "assets/images/g3.png",
        lastSentID: "You",
        lastSentTxt: "Hello,dshf??",
        timeShape: "22:54",
        status: true),
  ];


  @override
  Widget _buildChatItem(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 15.0),
      color: _chatList[index].status ? Color(0xfFF0541) : Colors.white,
      width: width,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        highlightColor: Colors.transparent,
        splashColor: Color(0xfFF0541),
        onPressed: () {
          setState(() {
            _chatList[index].status = false;
          });
        },
        child: Row(
          children: <Widget>[
            Container(
              width: width / 7,
              height: width / 7,
              margin: const EdgeInsets.only(right: 15.0),
              child: new CircleAvatar(
                backgroundImage: ExactAssetImage(_chatList[index].avatar),
                minRadius: width / 7,
                maxRadius: width / 7,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          _chatList[index].name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        _chatList[index].lastSentID + ": ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontFamily: 'Comfortaa'),
                      ),
                      Text(
                        _chatList[index].lastSentTxt,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontFamily: 'Comfortaa'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10.0),
              alignment: Alignment.centerRight,
              child: Text(
                _chatList[index].timeShape,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontFamily: 'Comfortaa'),
              ),
            )
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
      child: new ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: _buildChatItem,
        itemCount: _chatList.length,
      ),
    );
  }

}

// Screen
class ChatScreen extends StatefulWidget {

//  SocketIO socket;
//  SocketIOManager manager = SocketIOManager();

  @override
  State<StatefulWidget> createState() {
    return ChatState();
  }
}


class ChatState extends State<ChatScreen> {

//  ScrollController controller;
//
//  Future socketIO() async {
//    print("Socket");
//    SocketIOManager manager = SocketIOManager();
//    widget.socket = await manager.createInstance(SocketOptions(
//        socket_url,
//        nameSpace: "/",
//        //Query params - can be used for authentication
//        query: {
//          "auth": "--SOME AUTH STRING---",
//          "info": "new connection from adhara-socketio",
//          "timestamp": DateTime.now().toString()
//        },
//        //Enable or disable platform channel logging
//        enableLogging: false,
//        transports: [Transports.WEB_SOCKET/*, Transports.POLLING*/] //Enable required transport
//    ));
//    widget.socket.onConnect((data){
//      print("connected...");
//      print(data);
////      socket.emit("message", ["Hello world!"]);
//    });
////    socket.on("login", (data){   //sample event
////      print("login");
////      print(data);
////    });
////    socket.emit('join_room', ['abc']);
////
////    socket.on('join_success', (data){
////      print("Status Join Room");
////      print(data.chat);
////    });
////
////    socket.on('user_chat', (data){
////      print("User Chat Room");
////      print(data);
////    });
//    widget.socket.connect();
//  }

//  void joinRoom( room) async {
//    var data = {
//      'room': room,
//      'user': user_store.currentUser.id
//    };
//    widget.socket.emit('joinrooom', [data]);
//
//    widget.socket.on('join_room_status', (data){
//      if(data){
//        print('Join room successs');
//      }
//    });
//  }
//
//  void disconnectSocket(user) {
//    widget.socket.emit('disconnect', [user_store.currentUser.id]);
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    controller = new ScrollController()..addListener(_scrollListener);
//    socketIO();
//  }
//
//  void _scrollListener() {
//    if (controller.position.pixels == controller.position.maxScrollExtent) {
////      store.loadMore();
////      store.getPosts();
//      print("last");
//    }
//
//  }

  void detail_user(String userid) {


    if (userid == user_store.currentUser.id) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfileScreen(
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtherProfile(
                  otherId: userid,
                )),
      );
    }
  }

//  void goToSecondScreen(BuildContext context)async {
//    var result = await Navigator.push(context, new MaterialPageRoute(
//      builder: (BuildContext context) => new PrivateChatScreen(widget.socket),)
//    );
//
//    print("Return data: ${result}");
//
//    if(result) {
//      Navigator.pop(context);
//    }
//  }


  void _showDialog(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        // return AlertDialog(
        //   title: new Text("Alert Dialog title"),
        //   content: new Text("Alert Dialog body"),
        // );

        return Container(
          color: Color.fromRGBO(0, 0, 0, 0.4),
          child: GestureDetector(
            onTapDown: (s) {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    width: width,
                    bottom: height / 4.5,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: width*8.5/10,
                            height: (width*8.5/10) * 96 / 522,
                            margin: EdgeInsets.only(bottom: 15.0),
                            child: FlatButton(
                              onPressed: () {
//                                goToSecondScreen(context);
                              },
                              padding: EdgeInsets.all(0.0),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset("assets/images/khungchat.png"),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Private chat",
                                      style: TextStyle(
                                          fontFamily: 'Comfortaa',
                                          fontSize: 13.0,
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: width*8.5/10,
                            height: (width*8.5/10) * 96 / 522,
                            child: FlatButton(
                              onPressed: null,
                              padding: EdgeInsets.all(0.0),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset("assets/images/khungchat.png"),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Public chat room",
                                      style: TextStyle(
                                          fontFamily: 'Comfortaa',
                                          fontSize: 13.0,
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    width: width,
                    bottom: height / 4.5,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        width: width*8.5/10,
                        height: (width*8.5/10) * 96 / 522,
                        child: FlatButton(
                          onPressed: null,
                          padding: EdgeInsets.all(0.0),
                          child: Stack(
                            children: <Widget>[
                              Image.asset("assets/images/khungchat.png"),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Public chat room",
                                  style: TextStyle(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 13.0,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
            title: Text(
              "Chats",
              style: TextStyle(
                  color: Colors.black, fontSize: 20, fontFamily: 'Comfortaa'),
            ),
          ),
          preferredSize: Size.fromHeight(45)),
      body: new SafeArea(
        child: new Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            width: width * 8 / 10,
                            height: (width * 8 / 10) * 46 / 292,
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image:
                                    new AssetImage("assets/images/khung.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: new TextField(
                              decoration: new InputDecoration(
                                prefixIcon: new Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 5.0),
                                  child: new Icon(Icons.search),
                                ),
                                hintText: "Search people, chats room",
                                //contentPadding: new EdgeInsets.all(10),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              onChanged: (text) {
                                // code here
                              },
                            ),
                          ),
                          new Container(
                            child: GestureDetector(
                              onTap: () {
                                detail_user(user_store.currentUser.id);
                              },
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ),
                                        width: width / 7.2,
                                        height: width / 7.2,
                                      ),
                                  imageUrl: user_store.currentUser.picture,
                                  width: width / 7.2,
                                  height: width / 7.2,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width / 14.4),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              '${user_store.currentUser.following.length} FOLLOWINGS',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                  fontSize: 12),
                            ),
                          ),
                          new Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            width: 70.0,
                            height: 30.0,
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FollowAll()),
                                );
                              },
                              child: Text(
                                'VIEW ALL',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Comfortaa',
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 0.5, color: Colors.grey),
                              ),
                            ),
                            child: new Avatar(),
                          )),
                        ],
                      ),
                      new Container(
                        margin: EdgeInsets.all(10.0),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          "My Chats",
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: 'Comfortaa'),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60.0),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: new ChatItemsRender(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              width: width,
              bottom: 15.0,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  width: width / 1.5,
                  height: (width / 1.5) * 102 / 546,
                  alignment: Alignment.center,
                  child: FlatButton(
                    onPressed: () {
                      print("object");
                      _showDialog(context);
                    },
                    padding: EdgeInsets.all(0.0),
                    child: new Stack(
                      children: <Widget>[
                        Image.asset("assets/images/createChat.png"),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Create chat",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Comfortaa'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

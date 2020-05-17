import 'package:flutter/material.dart';
import 'package:vn_travel_app/features/home_chat/home_chat_view.dart';
//import 'package:adhara_socket_io/adhara_socket_io.dart';

// List Notification

//  final data = [
//    {"avatar":"cdjshfcsd","name":"dsfds","isChoose": true}
//  ]

class AccountItems {
  String avatar;
  String name;
  bool isChoose;

  AccountItems({this.avatar, this.name, this.isChoose});

  AccountItems.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    name = json['name'];
    isChoose = json['isChoose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['isChoose'] = this.isChoose;
    return data;
  }
}

class AllAccount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AllAccountState();
  }
}

class AllAccountState extends State<AllAccount> {
  final List<AccountItems> _listAccount = [
    new AccountItems(
        name: "Angelica", avatar: "assets/images/g3.png", isChoose: true),
    new AccountItems(
        name: "Mark", avatar: "assets/images/b3.png", isChoose: false),
    new AccountItems(
        name: "Wendy", avatar: "assets/images/bts10copy.png", isChoose: true),
    new AccountItems(
        name: "Alice", avatar: "assets/images/g3.png", isChoose: false),
    new AccountItems(
        name: "Love BTS", avatar: "assets/images/b3.png", isChoose: false),
    new AccountItems(
        name: "Worlwide hansome",
        avatar: "assets/images/bts10copy.png",
        isChoose: true),
    new AccountItems(
        name: "Jungkookies",
        avatar: "assets/images/bts10.png",
        isChoose: false),
  ];
  Widget _buildAccountItem(BuildContext context, int index) {
    // print("-------------------" +)
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return new Container(
      padding: EdgeInsets.all(10.0),
      color:
          this._listAccount[index].isChoose ? Color(0xfFF002B) : Colors.white,
      child: FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          setState(() {
            this._listAccount[index].isChoose =
                !this._listAccount[index].isChoose;
          });
        },
        child: Row(children: <Widget>[
          Container(
            width: width / 7,
            height: width / 7,
            margin: const EdgeInsets.only(right: 15.0),
            child: new CircleAvatar(
              backgroundImage: ExactAssetImage(_listAccount[index].avatar),
              minRadius: width / 7,
              maxRadius: width / 7,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                _listAccount[index].name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Comfortaa'),
              ),
            ),
          ),
          this._listAccount[index].isChoose
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.black54,
                  ),
                  margin: const EdgeInsets.only(right: 10.0),
                  child: FlatButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        setState(() {
                          this._listAccount[index].isChoose =
                              !this._listAccount[index].isChoose;
                        });
                      },
                      child: new RawMaterialButton(
                        shape: new CircleBorder(),
                        elevation: 0.0,
                        child: new Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()),);
                        },
                      )),
                )
              : Container(
                  width: 30,
                  height: 30,
                ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
      ),
      child: new ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: _buildAccountItem,
        itemCount: _listAccount.length,
      ),
    );
  }
}

// Notification
class PrivateChatScreen extends StatefulWidget {

//  SocketIO socket;

//  PrivateChatScreen(this.socket);

  @override
  State<StatefulWidget> createState() {
    return PrivateChatState();
  }
}

class PrivateChatState extends State<PrivateChatScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back, color: Colors.black, size: 30,),
            ),
            title: Text("Private chat",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Comfortaa')),
          ),
          preferredSize: Size.fromHeight(50.0)
      ),
      body: WillPopScope(
          child: SafeArea(
              child: new ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      // search box
//                      Padding(
//                        padding: const EdgeInsets.only(
//                          top: 10.0,
//                          left: 10.0,
//                        ),
//                        child: new Row(
//                          children: <Widget>[
//                            GestureDetector(
//                              onTap: (){
//                                Navigator.pop(context, true);
//                              },
//                              child: Container(
//                                width: 25,
//                                height: 25,
//                                margin: EdgeInsets.only(right: 20.0),
//                                child: Container(
//                                  child: Image.asset("assets/images/arrow_back.png"),
//                                ),
//                              ),
//                            ),
//                            Expanded(
//                              flex: 1,
//                              child: Container(
//                                  child: Text("Private chat",
//                                      style: TextStyle(
//                                          color: Colors.black,
//                                          fontSize: 18,
//                                          fontWeight: FontWeight.bold,
//                                          fontFamily: 'Comfortaa'))
//                              ),
//                            ),
//                            Container(
//                              width: 40.0,
//                              height: 40.0,
//                              margin: EdgeInsets.only(right: 10.0),
//                              child: CircleAvatar(
//                                backgroundImage:
//                                ExactAssetImage("assets/images/g4.png"),
//                                minRadius: 20,
//                                maxRadius: 20,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
                      new Container(
                        width: width - 20.0,
                        height: (width - 20.0) * 184 / 1392,
                        margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage("assets/images/khung.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: new TextField(
                          decoration: new InputDecoration(
                            prefixIcon: new Padding(
                              padding: const EdgeInsetsDirectional.only(start: 10.0),
                              child: new Icon(
                                Icons.search,
                                size: 30,
                              ),
                            ),
                            hintText: "Search",
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

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.all(10.0),
                        child: Text(
                          "My Follower",
                          style: TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
                        ),
                      ),
                      // list account

                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: new AllAccount(),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              )
          ),
          onWillPop: (){
            Navigator.pop(context, true);
          }
      ),
    );
  }
}

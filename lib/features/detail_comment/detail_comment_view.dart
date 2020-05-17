import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/utils/rest_api/comment_api.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_mobx/flutter_mobx.dart';
//import 'package:vn_travel_app/stores/posts_store.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vn_travel_app/features/other_profile/other_profile.dart';
import 'package:intl/intl.dart';
import 'package:vn_travel_app/model/post_infor.dart';
//import 'package:animator/animator.dart';

class DetailComment extends StatefulWidget {
  Comment cmt;

  DetailComment({Key key, @required this.cmt}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DetailCommentState();
  }
}

class DetailCommentState extends State<DetailComment> {
  String commemt_content = "";
  List<Comment> commentItems;
  bool checkMoreTitle = false;
  bool render = false;
  List<Comment> listCmt;
  int page = 1;
  bool loadMore = false;
  int showComment;
  final TextEditingController _controller = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentItems = new List<Comment>();
    listCmt = new List<Comment>();
    showComment = 10;
    getDataChildComment();
  }

//  void handleTimeout() {
//    _scrollController.animateTo(
//      0.0,
//      curve: Curves.easeOut,
//      duration: const Duration(milliseconds: 300),
//    );
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

  Future getDataChildComment() async {
    var childCmtRes =
    await getSubCommentByRefer2(widget.cmt.id, page, user_store.token);
    if (childCmtRes != null && childCmtRes.length > 0) {
      List<Comment> newListCommet = new List<Comment>();
      childCmtRes.forEach((item) {
        Comment cmtRes = Comment.fromJson(item);
        if (cmtRes.id != null) {
          newListCommet.add(cmtRes);
        }
      });
      setState(() {
        commentItems..addAll(newListCommet);
        commentItems.sort((a, b) =>
            DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
      });
    }
  }

  Future getMoreCommentData() async {
    var cmt =
    await getSubCommentByRefer2(widget.cmt.id, page, user_store.token);
    if (cmt != null && cmt.length > 0) {
      List<Comment> newListCommet = new List<Comment>();
      cmt.forEach((item) {
        Comment cmtRes = Comment.fromJson(item);
        if (cmtRes.id != null) {
          newListCommet.add(cmtRes);
        }
      });
      setState(() {
        commentItems..addAll(newListCommet);
        commentItems.sort((a, b) =>
            DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
        showComment += 10;
        loadMore = false;
      });
    }
  }
  void handleTimeout() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
//    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
  Future push_comment() async {
    if (commemt_content.trim() != "") {
      var cmtRes =
      await addComment(commemt_content, widget.cmt.id, user_store.token);
      if (cmtRes != null) {
        List<Comment> list = new List<Comment>();
        Comment newCmt = Comment.fromJson(cmtRes);
        list.add(newCmt);
        setState(() {
          commentItems..addAll(list);
          _controller.text = "";
          commemt_content = "";
        });

        await addSubComment(widget.cmt.id, newCmt.id, user_store.token);
        setState(() {
          widget.cmt.subComment.add(newCmt.id);
        });

      }
      handleTimeout();
    }

  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0), // here the desired height
        child: AppBar(
          backgroundColor: Colors.white,
          leading: new GestureDetector(
            onTap: () {
              Navigator.pop(context,true);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Stack(
            children: <Widget>[
              new ListView(
                controller: _scrollController,
                shrinkWrap: true,
                reverse: true,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(
                      bottom: 10.0,
                      top: 15,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: width / 9,
                              height: width / 9,
                              margin:
                              const EdgeInsets.only(right: 10.0, left: 10.0),
                              child: new FlatButton(
                                onPressed: () {
                                  detail_user(widget.cmt.author.id);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                child: Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            Colors.blue),
                                      ),
                                      width: width / 9,
                                      height: width / 9,
                                    ),
                                    imageUrl: widget.cmt.author.picture,
                                    width: width / 9,
                                    height: width / 9,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(width / 18),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                              ),
                            ),
                            Container(
                              width: width - (width / 9) - 20,
                              padding: EdgeInsets.only(right: 10.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 15.0, fontFamily: 'Comfortaa'
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: user_store.currentUser.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black , fontFamily: 'Comfortaa')),
                                    TextSpan(
                                        text: ' ' + widget.cmt.text + ' ',
                                        style: TextStyle(color: Colors.black , fontFamily: 'Comfortaa')),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: width - (width * 2 / 9) - 30.0,
                          height: 30.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DateFormat('dd MMM kk:mm')
                                    .format(DateTime.parse(widget.cmt.createdAt)),
                                style: TextStyle(color: Colors.grey[400], fontFamily: 'Comfortaa'),
                              ),
                            ],
                          ),
                        ),
                        widget.cmt.subComment.length >= 10 &&
                            widget.cmt.subComment.length > showComment
                            ? Container(
                          margin: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                loadMore = true;
                                page++;
                              });
                              getMoreCommentData();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                loadMore == false
                                    ? Container(
                                  child: Icon(
                                    Icons.replay,
                                    color: Colors.grey[800],
                                    size: 20,
                                  ),
                                )
                                : Icon(
                                  Icons.replay,
                                  color: Colors.grey[800],
                                  size: 20,
                                ),
//                                    : Animator(
//                                  tween:
//                                  Tween<double>(begin: 1, end: 0),
//                                  duration: Duration(seconds: 1),
//                                  repeats: 10,
//                                  builder: (anim) => RotationTransition(
//                                    turns: anim,
//                                    child: Icon(
//                                      Icons.replay,
//                                      color: Colors.grey[800],
//                                      size: 20,
//                                    ),
//                                  ),
//                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'View more comments',
                                    style: TextStyle(
                                        fontFamily: 'ComfortaaBold',
                                        fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                            : Container(),
                        ChildComment(
                          commentItems: commentItems,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: width / 10,
                          height: width / 9,
                          margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                          child: new Material(
                            child: user_store.currentUser.id != null
                                ? CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                                width: width / 9,
                                height: width / 9,
                                padding: EdgeInsets.all(15.0),
                              ),
                              imageUrl: user_store.currentUser.picture,
                              width: width / 9,
                              height: width / 9,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                              width: width / 9,
                              height: width / 9,
                              padding: EdgeInsets.all(15.0),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(width / 18),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                        ),
                        new Container(
                            width: width * 7 / 10,
                            height: (width * 7 / 10) * 46 / 292,
                            padding: EdgeInsets.only(left: 15.0, right: 15),
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new AssetImage("assets/images/khung.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: new TextField(
                                decoration: new InputDecoration(
                                  hintText: "Write your comment here",
                                  hintStyle: TextStyle(fontSize: 14.0),
                                  //contentPadding: new EdgeInsets.all(10),
                                  border: InputBorder.none,
                                ),
                                controller: _controller,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                onSubmitted: (value){
                                  push_comment();
                                },
                                onChanged: (text) {
                                  setState(() {
                                    commemt_content = text;
                                  });
                                },
                              ),
                            )),
                        new Container(
                          width: 40,
                          margin: EdgeInsets.only(right: 10.0),
                          child: new FlatButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            padding: EdgeInsets.all(0.0),
                            onPressed: () {
                              push_comment();
                            },
                            child: new Image.asset("assets/images/back_cricle.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class ChildComment extends StatefulWidget {
  // final String cmtId;
  final List<Comment> commentItems;
  ChildComment({Key key, @required this.commentItems}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChildCommentState();
  }
}

class ChildCommentState extends State<ChildComment> {
  //List<Comment> commentItems;

  String commemt_content = "";
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //commentItems = new List<Comment>();
    //getDataChildComment();
  }

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

  // Future getDataChildComment() async {
  //   var childCmtRes =
  //       await getSubCommentByRefer(widget.cmtId, user_store.token);
  //   if (childCmtRes != null && childCmtRes.length > 0) {
  //     List<Comment> newListCommet = new List<Comment>();
  //     childCmtRes.forEach((item) {
  //       Comment cmtRes = Comment.fromJson(item);
  //       if (cmtRes.id != null) {
  //         newListCommet.add(cmtRes);
  //       }
  //     });
  //     setState(() {
  //       commentItems..addAll(newListCommet);
  //       commentItems.sort((a, b) =>
  //           DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
  //     });
  //     print("All Sub Comment: ${commentItems.length}");
  //   }
  // }

  Widget _buildChildComment(BuildContext context, int indexChild) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      margin: EdgeInsets.only(left: width / 10, bottom: 5.0, top: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: width / 11,
                height: width / 11,
                margin: const EdgeInsets.only(right: 10.0, left: 15.0),
                child: new GestureDetector(
                  onTap: () {
                    detail_user(widget.commentItems[indexChild].author.id);
                  },
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        width: width / 11,
                        height: width / 11,
                      ),
                      imageUrl: widget.commentItems[indexChild].author.picture,
                      width: width / 11,
                      height: width / 11,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(width / 22),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
              ),
              Container(
                width: width * 7 / 10,
                padding: EdgeInsets.only(
                  right: 10.0,
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.commentItems[indexChild].author.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 12.0, fontFamily: 'Comfortaa'
                          )),
                      TextSpan(
                          text:
                          ' ' + widget.commentItems[indexChild].text + ' ',
                          style:
                          TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Comfortaa')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: width - (width * 2 / 9) - 75.0,
            height: 30.0,
            child: Text(
              DateFormat('dd MMM kk:mm').format(
                  DateTime.parse(widget.commentItems[indexChild].createdAt)),
              style: TextStyle(color: Colors.grey[400], fontFamily: 'Comfortaa'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(

//        margin: EdgeInsets.only(bottom: width/10),
        child: Stack(
          children: <Widget>[
            ListView(physics: ScrollPhysics(), shrinkWrap: true, children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: width / 8),
                child: widget.commentItems.length > 0
                    ? new ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int indexChild) {
                    return _buildChildComment(context, indexChild);
                  },
                  itemCount: widget.commentItems.length,
                )
                    : new Container(),
              ),
            ])
          ],
        ));
  }
}

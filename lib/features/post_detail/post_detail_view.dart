import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/model/user_login.dart';
import 'package:flutter/material.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:vn_travel_app/features/other_profile/other_profile.dart';
import 'package:vn_travel_app/features/detail_comment/detail_comment_view.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/utils/rest_api/comment_api.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';
//import 'package:animator/animator.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
import 'package:photo_view/photo_view.dart';
class ChildComment extends StatefulWidget {
  final String cmtId;
  final List<String> subCmt;
  final Comment listCmt;

  ChildComment(
      {Key key,
        @required this.cmtId,
        @required this.subCmt,
        @required this.listCmt})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChildCommentState();
  }
}

class ChildCommentState extends State<ChildComment> {
  List<Comment> commentItems;
  String commemt_content = "";
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentItems = new List<Comment>();
    getDataChildComment();
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

  Future getDataChildComment() async {
    // if (widget.subCmt.length > 0) {
    var childCmtRes =
    await getSubCommentByRefer(widget.cmtId, user_store.token);
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
    // }
  }

  Future push_comment() async {
    //
  }

  Widget _buildChildComment(BuildContext context, int indexChild) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      margin: EdgeInsets.only(left: 50.0, bottom: 5.0, top: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            width: width / 11,
            height: width / 11,
            margin: const EdgeInsets.only(right: 10.0, left: 15.0),
            child: new GestureDetector(
              onTap: () {
                detail_user(commentItems[indexChild].author.id);
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
                  imageUrl: commentItems[indexChild].author.picture,
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
                  fontSize: 15.0, fontFamily: 'Comfortaa'
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: commentItems[indexChild].author.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12.0, fontFamily: 'ComfortaaBold')),
                  TextSpan(
                      text: ' ' + commentItems[indexChild].text + ' ',
                      style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Comfortaa' )),
                ],
              ),
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
        child: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            widget.subCmt.length >= 3
                ? Container(
                margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailComment(
                              cmt: widget.listCmt,
                            )));
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: width / 5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey[400],
                                width: 0.3,
                                style: BorderStyle.solid)),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: new Text(
                          "See all replies",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Comfortaa',
                              color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ))
                : new Container(),
            Container(
              child: commentItems.length > 0
                  ? new ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int indexChild) {
                  return _buildChildComment(context, indexChild);
                },
                itemCount: commentItems.length,
              )
                  : new Container(),
            )
          ],
        ));
  }
}

//class Comments extends StatefulWidget {
//
//  final String postID;
//
//  Comments({
//    Key key,
//    @required this.postID,
//  }) : super(key: key);
//
//  @override
//  State<StatefulWidget> createState() {
//    return CommentState();
//  }
//}

//class CommentState extends State<Comments> {
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    listCmt = new List<Comment>();
//    getCommentData();
//  }
//
//  bool render = false;
//  int indexReply;
//  int page = 1;
//  List<Comment> listCmt;
//
//  Future getCommentData() async {
//    var cmt = await getCommentByRefer(widget.postID, page ,user_store.token);
//    if(cmt != null && cmt.length > 0){
//      List<Comment> newListCommet = new List<Comment>();
//      cmt.forEach((item){
//        Comment cmtRes = Comment.fromJson(item);
//        print("Comment: ${cmtRes.toJson()}");
//        if(cmtRes.id != null){
//          newListCommet.add(cmtRes);
//        }
//      });
//      newListCommet.sort((a,b) =>  DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)) );
//      setState(() {
//        listCmt..addAll(newListCommet);
//      });
//      print("All Comment: ${listCmt.length}");
//    }
//  }
//
//  void detail_user(String userid) {
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
//  }
//
//  Widget _buildComment(BuildContext context, int index) {
//    double width = MediaQuery.of(context).size.width;
//    double height = MediaQuery.of(context).size.height;
//    return new Container(
//      margin: EdgeInsets.only(
//        bottom: 10.0,
//      ),
//      child: Column(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Container(
//                width: width / 9,
//                height: width / 9,
//                margin: const EdgeInsets.only(right: 10.0, left: 10.0),
//                child: new FlatButton(
//                  onPressed: () {
//                    detail_user(listCmt[index].author.id);
//                  },
//                  splashColor: Colors.transparent,
//                  highlightColor: Colors.transparent,
//                  padding: EdgeInsets.all(0.0),
//                  child: Material(
//                    child: CachedNetworkImage(
//                      placeholder: (context, url) => Container(
//                        child: CircularProgressIndicator(
//                          strokeWidth: 1.0,
//                          valueColor:
//                          AlwaysStoppedAnimation<Color>(Colors.blue),
//                        ),
//                        width: width / 9,
//                        height: width / 9,
//                      ),
//                      imageUrl: listCmt[index].author.picture,
//                      width: width / 9,
//                      height: width / 9,
//                      fit: BoxFit.cover,
//                    ),
//                    borderRadius: BorderRadius.all(
//                      Radius.circular(width / 18),
//                    ),
//                    clipBehavior: Clip.hardEdge,
//                  ),
//                ),
//              ),
//              Container(
//                width: width - (width / 9) - 20,
//                padding: EdgeInsets.only(right: 10.0),
//                child: RichText(
//                  text: TextSpan(
//                    style: TextStyle(
//                      fontSize: 15.0,
//                    ),
//                    children: <TextSpan>[
//                      TextSpan(
//                          text: listCmt[index].author.name,
//                          style: TextStyle(
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black)),
//                      TextSpan(
//                          text: ' ' + listCmt[index].text + ' ',
//                          style: TextStyle(color: Colors.black)),
//                    ],
//                  ),
//                ),
//              ),
//            ],
//          ),
//          Container(
//            width: width - (width * 2 / 9) - 30.0,
//            height: 30.0,
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                Text(
//                  DateFormat('dd MMM kk:mm').format(
//                      DateTime.parse(listCmt[index].createdAt)),
//                  style: TextStyle(color: Colors.grey[400]),
//                ),
//                Container(
//                  width: 70.0,
//                  child: FlatButton(
//                    onPressed: () {
//                      if(index == indexReply){
//                        setState(() {
//                          indexReply = -1;
//                        });
//                      } else {
//                        setState(() {
//                          indexReply = index;
//                        });
//                      }
//                    },
//                    splashColor: Colors.transparent,
//                    highlightColor: Colors.transparent,
//                    padding: EdgeInsets.all(0.0),
//                    child: Text(
//                      "Reply",
//                      style: TextStyle(color: Colors.grey[400]),
//                    ),
//                  ),
//                )
//              ],
//            ),
//          ),
//          Observer(
//              builder: (_) => ChildComment(
//                cmtId: listCmt[index].id,
//                showReply: indexReply == index ? true : false,
//              )
//          )
//        ],
//      ),
//    );
//  }
//
//  // build comment
//  @override
//  Widget build(BuildContext context) {
//    double width = MediaQuery.of(context).size.width;
//    double height = MediaQuery.of(context).size.height;
//    return Container(
//      margin: EdgeInsets.only(top: 20.0),
//      child: listCmt.length > 0 ? new ListView.builder(
//        physics: ScrollPhysics(),
//        shrinkWrap: true,
//        scrollDirection: Axis.vertical,
//        itemBuilder: _buildComment,
//        itemCount: listCmt.length,
//      ) : Container(),
//    );
//  }
//
//}

class PostDetail extends StatefulWidget {
  Post postDetail;
  int index;
  PostDetail({Key key, @required this.postDetail,this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PostDetailState();
  }
}

class PostDetailState extends State<PostDetail> {
  String commemt_content = "";
  bool checkMoreTitle = false;
  bool render = false;
  bool isLoad = false;
  List<Comment> listCmt;
  int page = 1;
  bool loadMore = false;
  int showComment;
  bool isSaved;
  final TextEditingController _controller = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  bool renderScreen=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCmt = new List<Comment>();
    showComment = 10;
    getCommentData();
    isSaved = user_store.currentUser.saved.contains(widget.postDetail.id)
        ? true
        : false;
  }

  Future getCommentData() async {
    if (widget.postDetail.comment.length > 0) {
      var cmt =
      await getCommentByRefer(widget.postDetail.id, page, user_store.token);
      if (cmt != null && cmt.length > 0) {
        List<Comment> newListCommet = new List<Comment>();
        cmt.forEach((item) {
          Comment cmtRes = Comment.fromJson(item);
          if (cmtRes.id != null) {
            newListCommet.add(cmtRes);
          }
        });
        setState(() {
          listCmt..addAll(newListCommet);
          listCmt.sort((a, b) => DateTime.parse(a.createdAt)
              .compareTo(DateTime.parse(b.createdAt)));
        });
      }
    }
  }

  Future getMoreCommentData() async {
    if (widget.postDetail.comment.length > 0) {
      var cmt =
      await getCommentByRefer(widget.postDetail.id, page, user_store.token);
      if (cmt != null && cmt.length > 0) {
        List<Comment> newListCommet = new List<Comment>();
        cmt.forEach((item) {
          Comment cmtRes = Comment.fromJson(item);
          if (cmtRes.id != null) {
            newListCommet.add(cmtRes);
          }
        });
        setState(() {
          listCmt..addAll(newListCommet);
          listCmt.sort((a, b) => DateTime.parse(a.createdAt)
              .compareTo(DateTime.parse(b.createdAt)));
          showComment += 10;
          loadMore = false;
        });
      }
    }
  }

  void handleTimeout() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
//    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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

  Future push_comment() async {
    if (commemt_content.trim() != "") {
      var cmtRes = await addComment(
          commemt_content, widget.postDetail.id, user_store.token);
      if (cmtRes != null) {
        List<Comment> list = new List<Comment>();
        Comment newCmt = Comment.fromJson(cmtRes);
        list.add(newCmt);
        setState(() {
          listCmt..addAll(list);
          _controller.text = "";
          commemt_content = "";
        });
        await commentPost(newCmt.id, widget.postDetail.id, user_store.token);
        setState(() {
          widget.postDetail.comment.add(newCmt.id);
        });

      }
      handleTimeout();
    }
//    post_store.updatePosted(widget.postDetail, widget.index);
  }

  Future _likePost() async {
    List<String> list = widget.postDetail.like;
    if (widget.postDetail.like != null) {
      list.contains(user_store.currentUser.id)
          ? list.remove(user_store.currentUser.id)
          : list.add(user_store.currentUser.id);
    } else {
      list.add(user_store.currentUser.id);
    }
    setState(() {
      widget.postDetail.like = list;
    });
    await likePost(widget.postDetail.id, user_store.token);
  }

  Future<void> _shareImageFromUrl(String file) async {
    try {
      setState(() {
        isLoad = true;
      });
      var request = await HttpClient().getUrl(Uri.parse(file));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('BTS Social', 'image.jpg', bytes, 'image/jpg');
      setState(() {
        isLoad = false;
      });
    } catch (e) {
      setState(() {
        isLoad = false;
      });
      print('error: $e');
    }
  }

  Future sharePost() async {
    try {
      await _shareImageFromUrl( server_url + "/" + widget.postDetail.fullUrl);
    } catch (e) {
      print('error: $e');
    }
  }

  Future savePost() async {
    var saved = await savedPost(
        user_store.currentUser.id, widget.postDetail.id, user_store.token);
    User us = User.fromJson(saved);
    user_store.setCurrentUser(us);
//    await post_store.getSaveds();
    if(!isSaved){
      List<Post> listSavedNew=[]..addAll(post_store.saved);
      listSavedNew.removeWhere((item)=>item.id==widget.postDetail.id);
      post_store.setSaved(listSavedNew);
    }else{
      List<Post> listSavedNew= []..addAll(post_store.saved);
      listSavedNew.insert(0,widget.postDetail);
      post_store.setSaved(listSavedNew);
    }

  }

  void _showFullImage(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: PreferredSize(
              child: new AppBar(
                backgroundColor: Colors.black,
                leading: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: new Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    )),
              ),
              preferredSize: Size.fromHeight(45.0)),
          body: Container(
            child: PhotoView(
              imageProvider: NetworkImage(server_url + "/" +widget.postDetail.fullUrl),
        ),
          ),
        )));
  }
//  ScrollController _scrollController2 = new ScrollController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (widget.postDetail.id != null) {
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              backgroundColor: Colors.white,
              leading: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: new Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 25,
                  )),
            ),
            preferredSize: Size.fromHeight(45.0)),
        body: SafeArea(
            child: Stack(
              children: <Widget>[
                ListView(
                  controller: _scrollController,
                  // reverse: true,
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 25.0, top: 15.0),
                          decoration: new BoxDecoration(
                            border: Border(
                              bottom:
                              BorderSide(width: 0.5, color: Colors.grey[350]),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  detail_user(widget.postDetail.author.id);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        width: width / 7,
                                        height: width / 7,
                                        margin: const EdgeInsets.only(
                                            right: 10.0, left: 10.0),
                                        child: Container(
                                          child: Material(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                    child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 1.0,
                                                      valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.blue),
                                                    ),
                                                    width: width / 7,
                                                    height: width / 7,
                                                    padding: EdgeInsets.all(15.0),
                                                  ),
                                              imageUrl:
                                              widget.postDetail.author.picture,
                                              width: width / 7,
                                              height: width / 7,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(width / 14),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(bottom: 5.0),
                                            child: Text(
                                                widget.postDetail.author.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                TextStyle(color: Colors.black, fontFamily: 'ComfortaaBold')),
                                          ),
                                          Container(
                                            child: Text(
                                                DateFormat('dd MMM kk:mm').format(
                                                    DateTime.parse(widget
                                                        .postDetail.createdAt)),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12, fontFamily: 'Comfortaa')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: width,
                                      margin: const EdgeInsets.only(top: 15.0),
                                      child: new FlatButton(
                                          padding: EdgeInsets.all(0.0),
                                          onPressed: () {
                                            _showFullImage(context);
                                          },
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Hero(
                                            tag: "full_image_size",
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                    child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 1.0,
                                                      valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.blue),
                                                    ),
                                                    width: width / 7,
                                                    height: width / 7,
                                                    padding: EdgeInsets.all(15.0),
                                                  ),
                                              imageUrl: server_url + "/" + widget.postDetail.fullUrl,
                                              width: width,
                                              height: width,
                                              fit: BoxFit.cover,
                                            ),
                                          ))),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: width,
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10.0, right: 10.0),
                                        child: Text(
                                          "#${widget.postDetail.tag}",
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontFamily: 'Comfortaa',
                                              fontSize: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: width,
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10.0, right: 10.0),
                                        child: renderMoreTitle(),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: width,
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10.0, right: 10.0),
                                        child: Text(
                                          widget.postDetail.description,
                                          style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa', fontSize: 10),
                                        )
                                      )
                                    ],
                                  ),
//                                  FlatButton(
//                                      padding: EdgeInsets.all(10),
//                                      onPressed: () {
//                                        setState(() {
//                                          checkMoreTitle = !checkMoreTitle;
//                                        });
//                                      },
//                                      splashColor: Colors.transparent,
//                                      highlightColor: Colors.transparent,
//                                      child: new Text(
//                                        "${checkMoreTitle ? "Hide title" : "See all title"}",
//                                        style: TextStyle(
//                                            fontSize: 12,
//                                            color: Colors.blueAccent,
//                                            fontFamily: 'Comfortaa'),
//                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: _likePost,
                                      padding: EdgeInsets.all(0.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 20,
                                            height: 20 * 105 / 110,
                                            margin:
                                            const EdgeInsets.only(right: 5.0),
                                            child: widget.postDetail.like.contains(
                                                user_store.currentUser.id)
                                                ? Image.asset(
                                              "assets/images/hearted.png",
                                            )
                                                : Image.asset(
                                              "assets/images/heart.png",
                                            ),
                                          ),
                                          Text(
                                            "${widget.postDetail.like.length}",
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 14, fontFamily: 'Comfortaa'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: FlatButton(
                                      onPressed: handleTimeout,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      padding: EdgeInsets.all(0.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 20,
                                            height: 20,
                                            margin:
                                            const EdgeInsets.only(right: 5.0),
                                            child: Image.asset(
                                              "assets/images/chat.png",
                                            ),
                                          ),
                                          Text(
                                            "${widget.postDetail.comment.length}",
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 14, fontFamily: 'Comfortaa'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: sharePost,
                                      padding: EdgeInsets.all(0.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 20,
                                            height: 20,
                                            margin:
                                            const EdgeInsets.only(right: 5.0),
                                            child: Image.asset(
                                              "assets/images/share.png",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: width / 4.5,
                                      height: height / 20,
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 5.0,
                                          left: 10.0,
                                          right: 10.0),
                                      decoration: new BoxDecoration(
                                        //color: Colors.grey[350],
                                        color: isSaved
                                            ? Colors.grey[350]
                                            : Color(0xffFF002F),
                                        border: Border.all(
                                          color: isSaved
                                              ? Colors.grey[350]
                                              : Color(0xffFF002F),
                                        ),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                      ),
                                      child: FlatButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () async{
                                          setState(() {
                                            isSaved = !isSaved;
                                          });
                                          savePost();
//                                          List<Post> newspost=[]..addAll(post_store.saved);
//                                          newspost.add(widget.postDetail);
//                                          post_store.setSaved(newspost);

                                        },
                                        padding: EdgeInsets.all(0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/images/save.png",
                                              width: width / 20,
                                              height: width / 20,
                                            ),
                                            Text(
                                              isSaved?"Saved":"Save",
                                              //"${postDetail.save ? "Saved" : "Save"}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0, fontFamily: 'Comfortaa'),
                                            )
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// Check length list and show button render more
                        widget.postDetail.comment.length > 10 &&
                            widget.postDetail.comment.length > showComment
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

                        /// List Child Comment
                        listCmt.length != 0
                            ? Container(
                          margin: EdgeInsets.only(top: 20.0,bottom: (width * 7 / 10) * 46 / 292,),
                          child: new ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: _buildComment,
                            itemCount: listCmt.length,
                          ),
                        )
                            : Container(
                          child: widget.postDetail.comment.length <= 0
                              ? Text("No comment!")
                              : Container(
                            width: width / 4,
                            height: height / 8,
                            child: Image.asset(
                              "assets/images/loading.gif",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  child: isLoad
                      ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                      : Container(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: width / 9,
                            height: width / 9,
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
                              padding: EdgeInsets.only(left: 20.0, right: 15),
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
                            width: width / 10,
                            child: new FlatButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              padding: EdgeInsets.all(0.0),
                              onPressed: push_comment,
                              child:
                              new Image.asset("assets/images/back_cricle.png"),
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
    } else {
      return new Scaffold(
        body: new SafeArea(
          child: new Center(
            child: Container(
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              width: width / 6,
              height: width / 6,
            ),
          ),
        ),
      );
    }
  }

  Widget renderMoreTitle() {
    if (checkMoreTitle) {
      return Text(
        widget.postDetail.title,
        style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
      );
    } else {
      return Text(
        widget.postDetail.title,
        style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      );
    }
  }

  Widget _buildComment(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
//      width: width/6,
//      height: height/6,
      margin: EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: width / 9,
                height: width / 9,
                margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: new FlatButton(
                  onPressed: () {
                    detail_user(listCmt[index].author.id);
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
                          AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        width: width / 9,
                        height: width / 9,
                      ),
                      imageUrl: listCmt[index].author.picture,
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
                      fontSize: 15.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: listCmt[index].author.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, fontFamily: 'Comfortaa')),
                      TextSpan(
                          text: ' ' + listCmt[index].text + ' ',
                          style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa')),
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
                      .format(DateTime.parse(listCmt[index].createdAt)),
                  style: TextStyle(color: Colors.grey[400], fontFamily: 'Comfortaa'),
                ),
                Container(
                  width: 70.0,
                  child: FlatButton(
                    onPressed: ()async {

                      var render=await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailComment(cmt: listCmt[index])));
                      if(render != null && render){
                        setState(() {
                          renderScreen=!renderScreen;
                        });
                      }
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      "Reply",
                      style: TextStyle(color: Colors.grey[400], fontFamily: 'Comfortaa'),
                    ),
                  ),
                )
              ],
            ),
          ),
          listCmt[index].subComment.length > 0
              ? ChildComment(
            cmtId: listCmt[index].id,
            subCmt: listCmt[index].subComment,
            listCmt: listCmt[index],
          )
              : Container()
        ],
      ),
    );
  }
}

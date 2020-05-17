import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:vn_travel_app/model/user_login.dart' as prefix0;
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/utils/colors.dart';
import 'package:vn_travel_app/widgets/DetailFollow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vn_travel_app/features/post_detail/post_detail_view.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/model/user_login.dart';
import 'package:photo_view/photo_view.dart';

class OtherProfile extends StatefulWidget {
  final String otherId;

  OtherProfile({Key key, @required this.otherId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OtherProfileState(otherId: otherId);
  }
}

class OtherProfileState extends State<OtherProfile> {
  final String otherId;

  bool render = false;
  List<Post> posts;
  OtherProfileState({Key key, @required this.otherId});
  ScrollController controller;
  int quantity;
  bool isLinearMode;
  bool isLoad = false;
  bool isfolow = false;
  String pageChoosed = "Posted";
  bool isFollowing = false;
  User user;
  int post = 11;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = new User();
    controller = new ScrollController()..addListener(_scrollListener);
    posts = new List<Post>();
    isLinearMode = true;
    isFollowing = user_store.currentUser.following.contains(widget.otherId)
        ? true
        : false;
    getData();
    getPosts();
    quantity=1;
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      startLoader();
    }
//    if (controller.position.pixels == controller.position.minScrollExtent) {
//      post_store.getHomePost();
//    }
  }

  void startLoader() {
    setState(() {
      quantity += 1;
      fetchData();
    });
  }
  Future getData() async {
    var us = await getUserById(widget.otherId, user_store.token);
    User uss = User.fromJson(us);
    setState(() {
      user = uss;
    });
  }
  Future fetchData() async {
    var res = await getFeed(widget.otherId, user_store.token,quantity);
    var childPosts=res["rows"];
    if (childPosts != null && childPosts.length > 0) {
      List<Post> newListPost = new List<Post>();
      childPosts.forEach((item) {
        Post cmtRes = Post.fromJson(item);
        if (cmtRes.id != null) {
          newListPost.add(cmtRes);
        }
      });
      setState(() {
        posts..addAll(newListPost);

      });
    }
    // }
  }
  Future getPosts() async {
    var res = await getFeed(widget.otherId, user_store.token,1);
    var childPosts=res["rows"];
    if (childPosts != null && childPosts.length > 0) {
      List<Post> newListPost = new List<Post>();
      childPosts.forEach((item) {
        Post cmtRes = Post.fromJson(item);
        if (cmtRes.id != null) {
          newListPost.add(cmtRes);
        }
      });
      setState(() {
        posts=[]..addAll(newListPost);

      });
    }
    // }
  }

  Future checkFololow() async {
    // print("OherId: ${otherId} -- CurrentId: ${store.currentUserId}");
    // DataSnapshot snapshot = await databaseReference
    //     .child("followers")
    //     .child(otherId)
    //     .child(store.currentUserId)
    //     .once();
    // print("Check Follow: ${snapshot.value}");
    // if (snapshot.value != null) {
    //   setState(() {
    //     isFollowing = true;
    //   });
    // } else {
    //   setState(() {
    //     isFollowing = false;
    //   });
    // }
  }

  void detail_post(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostDetail(
            postDetail: posts[index],
          )),
    );
  }

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

  Future likePosts(int index) async {
    List<String> list = posts[index].like;
    if (posts[index].like != null) {
      list.contains(user_store.currentUser.id)
          ? list.remove(user_store.currentUser.id)
          : list.add(user_store.currentUser.id);
    } else {
      list.add(user_store.currentUser.id);
    }
    setState(() {
      posts[index].like = list;
    });
    await likePost(posts[index].id, user_store.token);
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

  Future sharePost(int index) async {
    try {
      await _shareImageFromUrl(posts[index].fullUrl);
    } catch (e) {
      print('error: $e');
    }
  }

  Future savePost(int index) async {}

  Future chooseButton(String name) async {
    setState(() {
      pageChoosed = name;
      isLoad = true;
    });

    setState(() {
      isLoad = false;
    });
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
                    child: new Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    )),
              ),
              preferredSize: Size.fromHeight(45.0)),
          body: Container(
            child: PhotoView(
              imageProvider: NetworkImage(user.picture),
            ),
          ),
        )));
  }

  Future followUser() async {
    setState(() {
      isFollowing = !isFollowing;
    });
    List<String> list = user_store.currentUser.following;
    List<String> listFollowers = user.follower;
    if (user_store.currentUser.following != null) {
      list.contains(widget.otherId)
          ? list.remove(widget.otherId)
          : list.add(widget.otherId);
    } else {
      list.add(widget.otherId);
    }
    if(user.follower != null){
      listFollowers.contains(user_store.currentUser.id)
          ? listFollowers.remove(user_store.currentUser.id)
          : listFollowers.add(user_store.currentUser.id);
    } else {
      listFollowers.add(user_store.currentUser.id);
    }
    User uss = user_store.currentUser;
    uss.following = list;
    setState(() {
      user.follower = listFollowers;
    });
    user_store.setCurrentUser(uss);
    await followed(user_store.currentUser.id, widget.otherId, user_store.token);
    await followerUser(
        user_store.currentUser.id, widget.otherId, user_store.token);
    post_store.getListFollow();
    post_store.getPost(user_store.currentUser.following);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              user.id != null
                  ? ListView(
                controller: controller,
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 15, left: 10, right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                //width: width*2/3,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: width / 5,
                                      margin: const EdgeInsets.only(
                                          right: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          _showFullImage(context);
                                        },
                                        child: Material(
                                          child: Observer(
                                            builder: (_) =>
                                            user.picture != null
                                                ? CachedNetworkImage(
                                              placeholder:
                                                  (context,
                                                  url) =>
                                                  Container(
                                                    child:
                                                    CircularProgressIndicator(
                                                      strokeWidth:
                                                      1.0,
                                                      valueColor:
                                                      AlwaysStoppedAnimation<Color>(Colors.blue),
                                                    ),
                                                    width:
                                                    width /
                                                        7,
                                                    height:
                                                    width /
                                                        7,
                                                    padding:
                                                    EdgeInsets.all(15.0),
                                                  ),
                                              imageUrl:
                                              user.picture,
                                              width: width / 5,
                                              height: width / 5,
                                              fit: BoxFit.cover,
                                            )
                                                : Container(
                                              child:
                                              CircularProgressIndicator(
                                                strokeWidth:
                                                1.0,
                                                valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(
                                                    Colors
                                                        .blue),
                                              ),
                                              width: width / 7,
                                              height: width / 7,
                                              padding:
                                              EdgeInsets
                                                  .all(
                                                  15.0),
                                            ),
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(width / 10),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: width / 3,
                                          margin: EdgeInsets.only(
                                              bottom: 10, right: 5),
                                          child: Observer(
                                            builder: (_) => Text(
                                              "${user.name}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                  'Comfortaa'),
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width / 3,
                                          margin:
                                          EdgeInsets.only(right: 5),
                                          child: Observer(
                                            builder: (_) => Text(
                                              "${user.aboutMe != null ? user.aboutMe : "About ${user.name}"}",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily:
                                                  'Comfortaa'),
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: width / 4,
                                height: height / 20,
                                margin:
                                const EdgeInsets.only(right: 10.0),
                                decoration: isFollowing
                                    ? new BoxDecoration(
                                  color: Colors.grey[350],
                                  border: Border.all(
                                    color: Colors.grey[350],
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.0)),
                                )
                                    : new BoxDecoration(
                                  color: Color(0xffFF002B),
                                  border: Border.all(
                                    color: Color(0xffFF002B),
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.0)),
                                ),
                                child: FlatButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () {
                                    followUser();
                                  },
                                  child: new Center(
                                    child: new Text(
                                      isFollowing ? "Unfollow" : "Follow",
                                      style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DetailFollow(
                          posts: posts.length.toString(),
                          following: user.following.length.toString(),
                          follows: user.follower.length.toString(),
                        ),
                        Container(
                          width: width,
                          margin: EdgeInsets.only(
                              left: 10, right: 10, top: 15, bottom: 15),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Container(
                                width: width * 7 / 10,
                                child: Row(
                                  children: <Widget>[
                                    _renderScreenButton(
                                        'Posted',
                                        pageChoosed == "Posted"
                                            ? MyColors.redButtonBackground
                                            : MyColors
                                            .clickedButtonBackground,
                                            () {
                                          chooseButton("Posted");
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  posts.length > 0
                      ? ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: _buildAvatarItem,
                    itemCount: posts.length,
                  )
                      : Container(
                      child: Center(
                        child: Container(
                          child: Text(
                              "There are currently no posts.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Comfortaa',
                                  fontSize: 12)),
                          margin: EdgeInsets.all(30),
                        ),
                      )),
                ],
              )
                  : Positioned(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  color: Colors.white.withOpacity(0.8),
                ),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarItem(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 25.0, top: 15.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 0.5, color: Colors.grey[350]),
          ),
        ),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: GestureDetector(
                      onTap: null,
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                            width: width / 7,
                            height: width / 7,
                            padding: EdgeInsets.all(15.0),
                          ),
                          imageUrl: user.picture,
                          width: width / 7,
                          height: width / 7,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(width / 14),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(posts[index].author.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          child: Text(
                              DateFormat('dd MMM kk:mm').format(
                                  DateTime.parse(posts[index].createdAt)),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                  fontFamily: 'Comfortaa')),
                        )
                      ],
                    ),
                  ),
                  //follow(context, posts[index].author.uid),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                    width: width,
                    height: width * 1628 / 1500,
                    margin: const EdgeInsets.only(top: 15.0),
                    child: new FlatButton(
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          detail_post(index);
                        },
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                            width: width / 7,
                            height: width / 7,
                            padding: EdgeInsets.all(15.0),
                          ),
                          imageUrl: server_url + "/" + posts[index].thumbUrl,
                          width: width,
                          height: width,
                          fit: BoxFit.cover,
                        ))),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: width,
                  padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    "#${posts[index].tag}",
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
                  padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    posts[index].title,
                    style:
                    TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      likePosts(index);
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20 * 105 / 110,
                          margin: const EdgeInsets.only(right: 5.0),
                          child: posts[index]
                              .like
                              .contains(user_store.currentUser.id)
                              ? Image.asset(
                            "assets/images/hearted.png",
                          )
                              : Image.asset(
                            "assets/images/heart.png",
                          ),
                        ),
                        Text(
                          posts[index].like.length.toString(),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Comfortaa'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {
                      detail_post(index);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 5.0),
                          child: Image.asset(
                            "assets/images/chat.png",
                          ),
                        ),
                        Text(
                          posts[index].comment.length.toString(),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Comfortaa'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      sharePost(index);
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 5.0),
                          child: Image.asset(
                            "assets/images/share.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _renderScreenButton(title, backgroundColor, callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
          margin: EdgeInsets.only(right: 15),
          height: 40,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: backgroundColor,
          ),
          child: new Center(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Comfortaa', fontSize: 12),
            ),
          )),
    );
  }
}

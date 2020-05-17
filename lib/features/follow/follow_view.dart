import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:vn_travel_app/features/post_detail/post_detail_view.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:vn_travel_app/features/follow_all/follow_all_view.dart';
import 'package:vn_travel_app/features/other_profile/other_profile.dart';
import 'package:vn_travel_app/features/search/search_view.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';
import 'package:vn_travel_app/model/user_login.dart';

class Avatar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AvatarState();
  }
}

class AvatarState extends State<Avatar> {
  ScrollController controller;

  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
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

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
//      store.loadMore();
//      store.getPosts();startLoader();
      startLoader();
    }
//    if (controller.position.pixels == controller.position.minScrollExtent) {
//      post_store.getPost(arrID);
//      setState(() {
//        page=1;
//        list = post_store.allPost;
//      });
//    }
  }

  void startLoader() {
    post_store.changePageFollow(post_store.pageFollow + 1);
    setState(() {
      fetchData();
    });
  }

  fetchData() async {
    if (this.mounted){
      setState((){
        isLoadMore=true;
      });
    }
    if (user_store.currentUser.following.length > 0) {
      var childUsers = await getListUserFollow(
          user_store.currentUser.id,
          user_store.currentUser.following.join(","),
          user_store.token,
          post_store.pageFollow);
      if (childUsers != null) {
        var users = childUsers['rows'];
        if (users != null && users.length > 0) {
          List<User> newListUser = new List<User>();
          users.forEach((item) {
            User cmtRes = User.fromJson(item);
            if (cmtRes.id != null) {
              newListUser.add(cmtRes);
            }
          });
          List<User> follows = []..addAll(post_store.follows);
          follows..addAll(newListUser);
          post_store.setFollows(follows);
        }
      }
    }
    if (this.mounted){
      setState((){
        isLoadMore=false;
      });
    }
  }

  Widget _buildAvatarItem(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      width: width / 5.5,
      margin: const EdgeInsets.only(right: 5.0),
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {},
        child: Column(
          children: <Widget>[
            Container(
              width: width / 7,
              height: width / 7,
              margin: const EdgeInsets.only(bottom: 5.0),
              child: GestureDetector(
                onTap: () {
                  detail_user(post_store.follows[index].id);
                },
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      width: width / 7,
                      height: width / 7,
                      padding: EdgeInsets.all(15.0),
                    ),
                    imageUrl: post_store.follows[index].picture,
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
            Container(
              child: Text(post_store.follows[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Comfortaa',
                      fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }
  bool isLoadMore=false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Observer(
        builder: (_) => user_store.currentUser.following.length > 0
            ? Container(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                height: height / 7,
                child: new ListView(
                  controller: controller,
//                  physics: ScrollPhysics(),
//                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    new ListView.builder(
//                      controller: controller,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: _buildAvatarItem,
                      itemCount: post_store.follows.length,
                    ),
                    isLoadMore?Container(
                        height: height/15,
                        width: height/15,
                        child:new Center(
                          child:  CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),

                          ),
                        )
                    ):Container()
                  ],
                )

              )
            : new Container());
  }
}

class Posts extends StatefulWidget {
  final String currentUserId;
  final Function callback;

  Posts({Key key, @required this.currentUserId, @required this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PostState(currentUserId: currentUserId);
  }
}

class PostState extends State<Posts> {
  final String currentUserId;
  List<Post> postfollow;
  bool render = false;

  PostState({Key key, @required this.currentUserId});

  @override
  void initState() {
    super.initState();

    postfollow = new List<Post>();
  }

  Widget follow(BuildContext context, String id) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (id == currentUserId) {
      return new Container();
    } else {
      return Container(
        width: width / 3.5,
        height: height / 23,
        margin: const EdgeInsets.only(right: 10.0),
        decoration: new BoxDecoration(
          color: Colors.grey[350],
          border: Border.all(
            color: Colors.grey[350],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: FlatButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
          onPressed: null,
          child: new Text("Following",
              style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa')),
        ),
      );
    }
  }

  void detail_post(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostDetail(
                postDetail: post_store.allPost[index],
              )),
    );
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

  Future likePosts(int index) async {
    List<String> list = post_store.allPost[index].like;
    if (post_store.allPost[index].like != null) {
      list.contains(user_store.currentUser.id)
          ? list.remove(user_store.currentUser.id)
          : list.add(user_store.currentUser.id);
    } else {
      list.add(user_store.currentUser.id);
    }
    setState(() {
      post_store.allPost[index].like = list;
    });
    await likePost(post_store.allPost[index].id, user_store.token);
  }

  Future<void> _shareImageFromUrl(String file) async {
    try {
      widget.callback(true);
      var request = await HttpClient().getUrl(Uri.parse(file));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('BTS Social', 'image.jpg', bytes, 'image/jpg');
      widget.callback(false);
    } catch (e) {
      widget.callback(false);
      print('error: $e');
    }
  }

  Future sharePost(int index) async {
    try {
      await _shareImageFromUrl(post_store.allPost[index].fullUrl);
    } catch (e) {
      print('error: $e');
    }
  }

  Future savePost(int index) async {}

  Widget _buildAvatarItem(BuildContext context, int index) {
    // print("-------------------" +)
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
              onTap: () {
                detail_user(post_store.allPost[index].author.id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          width: width / 7,
                          height: width / 7,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: post_store.allPost[index].author.picture,
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
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(post_store.allPost[index].author.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          child: Text(
                              DateFormat('dd MMM kk:mm').format(DateTime.parse(
                                  post_store.allPost[index].createdAt)),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                  fontFamily: 'Comfortaa')),
                        )
                      ],
                    ),
                  ),
                  // follow(context, post_store.allPost[index].author.id),
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                            width: width / 7,
                            height: width / 7,
                            padding: EdgeInsets.all(15.0),
                          ),
                          imageUrl: server_url + "/" + post_store.allPost[index].thumbUrl,
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
                    "#${post_store.allPost[index].tag}",
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
                    post_store.allPost[index].title,
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
                  //margin: const EdgeInsets.only(left: 10.0),
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
                          child: post_store.allPost[index].like
                                  .contains(user_store.currentUser.id)
                              ? Image.asset(
                                  "assets/images/hearted.png",
                                )
                              : Image.asset(
                                  "assets/images/heart.png",
                                ),
                        ),
                        Observer(
                          builder: (_) => Text(
                            "${post_store.allPost[index].like.length}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontFamily: 'Comfortaa'),
                          ),
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
                        Observer(
                          builder: (_) => Text(
                            "${post_store.allPost[index].comment.length}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: 'Comfortaa'),
                          ),
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Observer(
            builder: (_) => post_store.allPost.length > 0
                ? Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Observer(
                      builder: (_) => new ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: _buildAvatarItem,
                        itemCount: post_store.allPost.length,
                      ),
                    ),
                  )
                : Container(
                    child: Center(
                    child: Container(
                      height: height,
                      width: width,
                      child: new ListView(
                        children: <Widget>[
                          Text(
                              "There are currently no posts. Follow people or post new.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Comfortaa',
                                  fontSize: 12)),
                        ],
                      ),
                      margin: EdgeInsets.all(30),
                    ),
                  ))),
      ],
    );
  }
}

// Screen
class FollowScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return FollowState();
  }
}

class FollowState extends State<FollowScreen> {

  bool isLoad = false;
  ScrollController controller;

  int page;

  bool isLoading = false;


  void detail_user() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfileScreen(
              )),
    );
  }

  void load(bool values) {
    setState(() {
      isLoad = values;
    });
  }

  void _onFocusChange() {
    //store.getAllPostsFoSearch();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    page = 1;
    controller = new ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
//      store.loadMore();
//      store.getPosts();startLoader();
      startLoader();
    }
//    if (controller.position.pixels == controller.position.minScrollExtent) {
//      post_store.getPost(arrID);
//      setState(() {
//        page=1;
//        list = post_store.allPost;
//      });
//    }
  }

  void startLoader() {
    setState(() {
      page += 1;
      fetchData();
    });
  }

//  fetchData2() async {
//    var childUsers = await getListUserFollow(user_store.currentUser.id,
//        user_store.currentUser.following.join(","), user_store.token, page2);
//    var users = childUsers['rows'];
//    if (users != null && users.length > 0) {
//      List<User> newListUser = new List<User>();
//      users.forEach((item) {
//        User cmtRes = User.fromJson(item);
//        if (cmtRes.id != null) {
//          newListUser.add(cmtRes);
//        }
//      });
//      post_store.addListFollow(newListUser);
//    }
//  }

  fetchData() async {
    if (this.mounted) {
      setState(() {
        isLoadMore = true;
      });
    }
//    List<String> arrID = user_store.currentUser.following;
//    arrID.add(user_store.currentUser.id);
    var res = await getFollowFeed(
        user_store.currentUser.following.join(","), page, user_store.token);
    var respond = res["rows"];
    if (respond != null && respond.length > 0) {
      List<Post> newPostAll = new List<Post>();
      respond.forEach((item) {
        Post postRes = Post.fromJson(item);
        if (postRes.id != null) {
          newPostAll.add(postRes);
        }
      });
      List<Post> list = post_store.allPost;
      setState(() {
        list..addAll(newPostAll);
      });

      post_store.setPost(list);
      setState(() {
        isLoading = false;
      });

    }
    if (this.mounted) {
      setState(() {
        isLoadMore = false;
      });
    }
  }

  Future<Null> refreshPost() async {
    await post_store.getPost(user_store.currentUser.following);
    await post_store.getListFollow();
    post_store.changePageFollow(1);
    setState(() {
//      list = []..addAll(post_store.allPost);
      page = 1;
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() {
    return refreshPost();
  }

  bool isLoadMore = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: ListView(
            controller: controller,
            children: <Widget>[
              new Column(
                children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.only(left: 20.0),
//                  child: new Row(
//                    children: <Widget>[
//                      new Text(
//                        "Pictures",
//                        style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 20,
//                          fontFamily: 'Comfortaa',
//                        ),
//                      ),
//                      new Container(
//                          padding: EdgeInsets.all(0.0),
//                          //onPressed: null,
//                          width: 30.0,
//                          child: FlatButton(
//                              splashColor: Colors.transparent,
//                              highlightColor: Colors.transparent,
//                              onPressed: () => {print("object")},
//                              padding: EdgeInsets.all(0.0),
//                              child: new Icon(
//                                Icons.arrow_drop_down,
//                                size: 30,
//                                color: Colors.black,
//                              ))),
//                    ],
//                  ),
//                ),
                  new Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: width - width / 4.5,
                          height: ((width - width / 4.5) * 46) / 292,
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image:
                                  new AssetImage("assets/images/searchBox.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: new TextField(
                            onTap: () {
                              _onFocusChange();
                            },
                            style: TextStyle(fontFamily: 'Comfortaa'),
                            decoration: new InputDecoration(
                              prefixIcon: new Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 5.0),
                                child: new Icon(Icons.search),
                              ),
                              hintText: "Search",
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
                              detail_user();
                            },
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
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
                        child: new Avatar(),
                      ),
                    ],
                  ),
                  Observer(
                    builder: (_) => new Posts(
                      callback: load,
                    ),
                  ),
                  Container(
                    height: 40,
                    color: Colors.white,
                  ),
                  isLoadMore
                      ? Container(
                          height: height / 10,
                          child: new Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.pinkAccent),
                            ),
                          ))
                      : Container()
                ],
              ),
            ],
          ),
        ),
        Positioned(
          child: isLoad
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
    ));
  }
}

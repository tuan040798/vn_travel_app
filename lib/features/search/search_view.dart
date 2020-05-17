import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:vn_travel_app/model/user_login.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:vn_travel_app/features/post_detail/post_detail_view.dart';
import 'package:vn_travel_app/features/other_profile/other_profile.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';
class SearchType {
  String name;
  bool isClick;

  SearchType({this.name, this.isClick});

  SearchType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isClick = json['isClick'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['isClick'] = this.isClick;
    return data;
  }
}

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSearch = [
      new SearchType(name: "Post Name", isClick: true),
      new SearchType(name: "People", isClick: false),
    ];
    controller = new TextEditingController();
    scrollController = new ScrollController()..addListener(_scrollListener);
  }

  ScrollController scrollController;

  List<SearchType> listSearch;

  bool isLoading = false;
  bool render = false;
  int searchPostPage=1;
  int searchUserPage=1;
  String searchValue = "";
  List<User> searchUserList = new List<User>();
  List<Post> searchPostList = new List<Post>();
  TextEditingController controller;
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      startLoader();
      print("last");
    }
//    if (controller.position.pixels == controller.position.minScrollExtent) {
//      post_store.getHomePost();
//    }
  }
  void startLoader() {
    setState(() {
      if (listSearch[0].isClick) {
        searchPostPage++;
        fetchDataPost(searchValue, searchPostPage);
      }
      else{
        searchUserPage++;
        fetchDataUser(searchValue, searchUserPage);
      }


    });
  }
  Future chooseType(String searchType, int index) async {
//    setState(() {
//      isLoading = true;
//    });
//    print(searchType);
//    if(searchType == "Post Name"){
//      if(store.searchPosts.length > 0) {
//        List<Post> list = new List<Post>();
//        store.searchPosts.asMap().forEach((int idx, Post post){
//          if(post.title.toLowerCase().contains(searchValue.toLowerCase())){
//            list.add(post);
//            setState(() {
//              postNames = list;
//            });
//          }
//        });
//      }
//    } else if(searchType == "Boards"){
//      if(store.searchPosts.length > 0) {
//        List<PostData> list = new List<PostData>();
//         store.searchPosts.asMap().forEach((int idx, PostData post){
//          if(post.tag.toLowerCase().contains(searchValue.toLowerCase())){
//            list.add(post);
//            setState(() {
//              postTag = list;
//            });
//          }
//        });
//      }
//    }  else if(searchType == "People"){
//    }
//
    for (int i = 0; i < listSearch.length; i++) {
      if (index == i) {
        setState(() {
          listSearch[i].isClick = true;
        });
      } else {
        setState(() {
          listSearch[i].isClick = false;
        });
      }
    }
//    setState(() {
//      isLoading = false;
//    });
  }


  void refreshSearch() {
    searchPostList = new List<Post>();
    searchUserList = new List<User>();
  }

  Future<Null> fetchDataUser(String tag,int quantity) async {
    if (this.mounted){
      setState((){
        isLoadMore=true;
      });
    }
    var res = await getUser(quantity, user_store.token, tag);
    var respond = res["rows"];
    if (respond != null && respond.length > 0) {
      List<User> newUserAll = new List<User>();
      respond.forEach((item) {
        User userRes = User.fromJson(item);
        if (userRes.id != null) {
          newUserAll.add(userRes);
        }
      });
      setState(() {
        searchUserList..addAll(newUserAll);
      });

    }
    if (this.mounted){
      setState((){
        isLoadMore=false;
      });
    }
    print("user response: ${searchUserList.length}");
  }
  Future<Null> searchUser(String tag) async {
    if (this.mounted){
      setState((){
        isLoadMore=true;
      });
    }
    var res = await getUser(1, user_store.token, tag);
    var respond = res["rows"];
    if (respond != null && respond.length > 0) {
      List<User> newUserAll = new List<User>();
      respond.forEach((item) {
        User userRes = User.fromJson(item);
        if (userRes.id != null) {
          newUserAll.add(userRes);
        }
      });

      searchUserList = []..addAll(newUserAll);
    }
    print("user response: ${searchUserList.length}");
    if (this.mounted){
      setState((){
        isLoadMore=false;
      });
    }
  }
  Future<Null> fetchDataPost(String title,int quantity) async {
    if (this.mounted){
      setState((){
        isLoadMore=true;
      });
    }
    var res = await getAllPostByTag(quantity, user_store.token, title);
    var respond = res["rows"];
    if (respond != null && respond.length > 0) {
      List<Post> newPostAll = new List<Post>();
      respond.forEach((item) {
        Post postRes = Post.fromJson(item);
        if (postRes.id != null) {
          newPostAll.add(postRes);
        }
      });
      setState(() {
        searchPostList..addAll(newPostAll);
      });

    }
    if (this.mounted){
      setState((){
        isLoadMore=false;
      });
    }
  }
  Future<Null> searchPost(String title) async {
    if (this.mounted){
      setState((){
        isLoadMore=true;
      });
    }
    var res = await getAllPostByTag(1, user_store.token, title);
    var respond = res["rows"];
    if (respond != null && respond.length > 0) {
      List<Post> newPostAll = new List<Post>();
      respond.forEach((item) {
        Post postRes = Post.fromJson(item);
        if (postRes.id != null) {
          newPostAll.add(postRes);
        }
      });
      searchPostList = []..addAll(newPostAll);
    }
    if (this.mounted){
      setState((){
        isLoadMore=false;
      });
    }
  }

  void detail_post(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostDetail(
                postDetail: searchPostList[index],
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
bool isLoadMore=false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(bottom: 10, top: 10),
                width: width,
                child: new Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: new Icon(
                          Icons.arrow_back,
                          color: Colors.blueAccent,
                          size: 25,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 8.5 / 10,
                      height: ((width * 8.5 / 10) * 46) / 292,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/searchBox.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: new TextField(
                        autofocus: true,
                        onTap: () async {
                          await refreshSearch();
                          setState(() {
                            render = !render;
                          });
                        },
                        onSubmitted: (value) async {
                          await searchPost(value);
                          await searchUser(value);
                          setState(() {
                            render = !render;
                            searchValue=value;
                          });
                        },
                        style: TextStyle(fontFamily: 'Comfortaa'),
                        decoration: new InputDecoration(
                          prefixIcon: new Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 5.0),
                            child: new Icon(Icons.search),
                          ),
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        controller: controller,
                        autocorrect: false,
                        onChanged: (text) {
                          setState(() {
//                            searchValue = text;
                          searchUserList=new List<User>();
                          searchPostList=new List<Post>();
                          searchUserPage=1;
                          searchPostPage=1;
//                            if (listSearch[0].isClick) {
//                              chooseType(listSearch[0].name, 0);
//                            } else if (listSearch[1].isClick) {
//                              chooseType(listSearch[1].name, 0);
//                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    buildItem(context, 0),
                    buildItem(context, 1),
                  ],
                ),
              ),
              searchValue != ""
                  ? Container(
                      margin: EdgeInsets.only(top: 10),
                      child: renderList(context),
                    )
                  : Container(),
              isLoadMore?Container(
                  height: height/10,
                  child:new Center(
                    child:  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),

                    ),
                  )
              ):Container()
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
          )
        ],
      )),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
        height: height / 18,
        decoration: BoxDecoration(
          color:
              listSearch[index].isClick ? Colors.redAccent : Colors.grey[350],
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: new FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              chooseType(listSearch[index].name, index);
            },
            child: new Text(
              listSearch[index].name,
              style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa'),
            )));
  }

  Widget renderList(BuildContext context) {
    if (listSearch[0].isClick) {
      if (searchPostList.length > 0) {
        print("PostName : ${searchPostList.length}");
        return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: _buildPostName,
          itemCount: searchPostList.length,
        );
      } else {
        new Container(
          child: Center(
            child: Text(
              "Không tìm thấy kết quả nào phù hợp",
              style: TextStyle(fontFamily: 'Comfortaa', fontSize: 14),
            ),
          ),
        );
      }
    } else if (listSearch[1].isClick) {
      if (searchUserList.length> 0) {
        return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: _buildUser,
          itemCount: searchUserList.length,
        );
      } else {
        new Container(
          child: Center(
            child: Text(
              "Không tìm thấy kết quả nào phù hợp",
              style: TextStyle(fontFamily: 'Comfortaa', fontSize: 14),
            ),
          ),
        );
      }
    }
  }

  Widget _buildPostName(BuildContext context, int index) {
    // print("-------------------" +)
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Observer(
      builder: (_) => SafeArea(
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
                  detail_user(searchPostList[index].author.id);
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
                          imageUrl: searchPostList[index].author.picture,
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
                            child: Text(searchPostList[index].author.name,
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
                                    DateTime.parse(
                                        searchPostList[index].createdAt)),
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
                            imageUrl: server_url + "/" + searchPostList[index].thumbUrl,
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
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    child: Text(
                      "#${searchPostList[index].tag}",
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
                    child: Text(
                      searchPostList[index].title,
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Comfortaa'),
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
                            child: searchPostList[index]
                                    .like
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
                              "${searchPostList[index].like.length}",
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
                              "${searchPostList[index].comment.length}",
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
      ),
    );
//    return new Container(
//      width: width / 5.5,
//      margin: const EdgeInsets.only(right: 5.0),
//      child: FlatButton(
//        padding: EdgeInsets.all(0.0),
//        splashColor: Colors.transparent,
//        highlightColor: Colors.transparent,
//        onPressed: () {
//        },
//        child: Column(
//          children: <Widget>[
//            Container(
//              width: width / 7,
//              height: width / 7,
//              margin: const EdgeInsets.only(bottom: 5.0),
//              child: GestureDetector(
//                onTap: () {
//                  detail_user(post_store.follows[index].id);
//                },
//                child: Material(
//                  child: CachedNetworkImage(
//                    placeholder: (context, url) => Container(
//                      child: CircularProgressIndicator(
//                        strokeWidth: 1.0,
//                        valueColor:
//                        AlwaysStoppedAnimation<Color>(Colors.blue),
//                      ),
//                      width: width / 7,
//                      height: width / 7,
//                      padding: EdgeInsets.all(15.0),
//                    ),
//                    imageUrl: post_store.follows[index].picture,
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
//              child: Text(post_store.follows[index].name,
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

  Future likePosts(int index) async {
    List<String> list = searchPostList[index].like;
    if (searchPostList[index].like != null) {
      list.contains(user_store.currentUser.id)
          ? list.remove(user_store.currentUser.id)
          : list.add(user_store.currentUser.id);
    } else {
      list.add(user_store.currentUser.id);
    }
    setState(() {
      searchPostList[index].like = list;
    });
    await likePost(searchPostList[index].id, user_store.token);
  }

  Future sharePost(int index) async {
    try {
      await _shareImageFromUrl(searchPostList[index].fullUrl);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImageFromUrl(String file) async {
    try {
//      widget.callback(true);
      var request = await HttpClient().getUrl(Uri.parse(file));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('BTS Social', 'image.jpg', bytes, 'image/jpg');
//      widget.callback(false);
    } catch (e) {
//      widget.callback(false);
      print('error: $e');
    }
  }
  Future followUser(String otherId, int index) async {
    List<String> list = user_store.currentUser.following;
    if (user_store.currentUser.following != null) {
      list.contains(otherId) ? list.remove(otherId) : list.add(otherId);
    } else {
      list.add(otherId);
    }
    User uss = user_store.currentUser;
    uss.following = list;
    user_store.setCurrentUser(uss);
    await followed(user_store.currentUser.id, otherId, user_store.token);
    await followerUser(user_store.currentUser.id, otherId, user_store.token);

    post_store.getListFollow();
    post_store.getPost(user_store.currentUser.following);
  }
  Widget _buildUser(BuildContext context, int index) {
    // print("-------------------" +)
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      margin: const EdgeInsets.only(bottom: 15.0, left: 10.0),
      child: FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        padding: EdgeInsets.all(0.0),
        onPressed: null,
        child: Row(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(right: 10),
              width: width / 7,
              height: width / 7,
              child: GestureDetector(
                onTap: () {
                  detail_user(searchUserList[index].id);
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
                    ),
                    imageUrl: searchUserList[index].picture,
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
              child: Container(
                child: Text(
                  searchUserList[index].name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold, fontFamily: 'ComfortaaBold'
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            user_store.currentUser.id!=searchUserList[index].id?Container(
              width: width / 4,
              height: height / 20,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: user_store.currentUser.following
                      .contains(searchUserList[index].id)
                  ? new BoxDecoration(
                      color: Colors.grey[350],
                      border: Border.all(
                        color: Colors.grey[350],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    )
                  : new BoxDecoration(
                      color: Color(0xffFF002B),
                      border: Border.all(
                        color: Color(0xffFF002B),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
              child: FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                onPressed: () {

                  followUser(searchUserList[index].id, index);
                  setState(() {
                    render=!render;
                  });
                },
                child: new Text(
                  user_store.currentUser.following
                          .contains(searchUserList[index].id)
                      ? "Unfollow"
                      : "Follow",
                  style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa'),
                ),
              ),
            ):Container(),
          ],
        ),
      ),
    );
//    return new Container(
//      margin: const EdgeInsets.only(bottom: 15.0, left: 10.0),
//      child: FlatButton(
//        highlightColor: Colors.transparent,
//        splashColor: Colors.transparent,
//        padding: EdgeInsets.all(0.0),
//        onPressed: null,
//        child: Row(
//          children: <Widget>[
//            new Container(
//              margin: EdgeInsets.only(right: 10),
//              width: width / 7,
//              height: width / 7,
//              child: GestureDetector(
//                onTap: (){
//                  detail_user(searchUserList[index].id);
//                },
//                child: Material(
//                  child: CachedNetworkImage(
//                    placeholder: (context, url) => Container(
//                      child: CircularProgressIndicator(
//                        strokeWidth: 1.0,
//                        valueColor: AlwaysStoppedAnimation<Color>(
//                            Colors.blue),
//                      ),
//                      width: width / 7,
//                      height: width / 7,
//                    ),
//                    imageUrl: searchUserList[index].picture,
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
//            Expanded(
//              flex: 1,
//              child: Container(
//                child: Text(
//                  searchUserList[index].name,
//                  style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 16,
//                      fontWeight: FontWeight.bold),
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
//                ),
//              ),
//            ),
//            Container(
//              width: width / 4,
//              height: height / 25,
//              margin: const EdgeInsets.only(right: 10.0),
//              decoration: user_store.currentUser.following.contains(searchUserList[index].id)
//                  ? new BoxDecoration(
//                color: Colors.grey[350],
//                border: Border.all(
//                  color: Colors.grey[350],
//                ),
//                borderRadius: BorderRadius.all(Radius.circular(30.0)),
//              )
//                  : new BoxDecoration(
//                color: Color(0xffFF002B),
//                border: Border.all(
//                  color: Color(0xffFF002B),
//                ),
//                borderRadius: BorderRadius.all(Radius.circular(30.0)),
//              ),
//              child: FlatButton(
//                highlightColor: Colors.transparent,
//                splashColor: Colors.transparent,
//                padding: const EdgeInsets.only(
//                    left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
//                onPressed: () {
//                  followUser(searchUserList[index].id, index);
//                },
//                child: new Text(
//                  user_store.currentUser.following.contains(searchUserList[index].id) ? "Unfollow" : "Follow",
//                  style: TextStyle(color: Colors.white),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
  }
}

import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:vn_travel_app/utils/colors.dart';
import 'package:vn_travel_app/widgets/DetailFollow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
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
import 'package:vn_travel_app/features/other_profile/other_profile.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';

class Profile extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  ScrollController controller;
  bool render = false;
  int postedPage;
  int savedPage;

  bool isLinearMode;
  bool isLoad = false;
  String pageChoosed = "Posted";
  List<Post> posts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posts = new List<Post>();
    posts = post_store.posted;
    isLinearMode = true;
    // getPosts();
    controller = new ScrollController()..addListener(_scrollListener);
    postedPage = 1;
    savedPage = 1;
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
    fetchData();
  }

  void fetchData() async {
    if (this.mounted) {
      setState(() {
        isLoadMore = true;
      });
    }
    if (pageChoosed == "Posted") {
      postedPage++;
      var res =
          await getListPosted(user_store.currentUser.id, user_store.token, postedPage);
      if(res!=null){
        var childPosts=res["rows"];
        if (childPosts != null && childPosts.length > 0) {
          List<Post> newListPost = new List<Post>();
          childPosts.forEach((item) {
            Post cmtRes = Post.fromJson(item);
            if (cmtRes.id != null) {
              newListPost.add(cmtRes);
            }
          });
          List<Post> list=new List<Post>();
          list=[]..addAll(post_store.posted);
          list..addAll(newListPost);
          post_store.setPosted(list) ;
          setState(() {
            render=!render;
          });

        }
      }

    } else {
      savedPage++;
      if (user_store.currentUser.saved.length > 0) {
        var res = await getSaved(user_store.currentUser.saved.join(","),
            user_store.token, savedPage);
        var childPosts=res["row"];
        if (childPosts != null && childPosts.length > 0) {
          List<Post> newListPost = new List<Post>();
          childPosts.forEach((item) {
            Post cmtRes = Post.fromJson(item);
            if (cmtRes.id != null) {
              newListPost.add(cmtRes);
            }
          });
          List<Post> list=new List<Post>();
          list=[]..addAll(post_store.saved);
          list..addAll(newListPost);
          post_store.setSaved(list) ;
          setState(() {
            render=!render;
          });

        }
      }
    }
    if (this.mounted) {
      setState(() {
        isLoadMore = false;
      });
    }
  }

  void detail_post(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostDetail(
                postDetail:  pageChoosed == "Posted" ?(post_store.posted[index] ): (post_store.saved[index]),
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

  // Future getPosts() async {
  //   var childPosts = await getFeed(user_store.currentUser.id, user_store.token);
  //   if (childPosts != null && childPosts.length > 0) {
  //     List<Post> newListPost = new List<Post>();
  //     childPosts.forEach((item) {
  //       Post cmtRes = Post.fromJson(item);
  //       if (cmtRes.id != null) {
  //         newListPost.add(cmtRes);
  //       }
  //     });
  //     setState(() {
  //       posts..addAll(newListPost);
  //       posts.sort((a, b) =>
  //           DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
  //     });
  //     print("All Sub Comment: ${posts.length}");
  //   }
  //   // }
  // }

  Future likePosts(int index) async {
    List<String> list = pageChoosed == "Posted" ?(post_store.posted[index].like): (post_store.saved[index].like);
    if (pageChoosed == "Posted" ?(post_store.posted[index].like != null): (post_store.saved[index].like != null)) {
      list.contains(user_store.currentUser.id)
          ? list.remove(user_store.currentUser.id)
          : list.add(user_store.currentUser.id);
    } else {
      list.add(user_store.currentUser.id);
    }
    setState(() {
      posts[index].like = list;
    });
    await likePost(pageChoosed == "Posted" ?(post_store.posted[index].id): (post_store.saved[index].id), user_store.token);
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
      await _shareImageFromUrl(pageChoosed == "Posted" ?( server_url + "/" + post_store.posted[index].fullUrl): ( server_url + "/" + post_store.saved[index].fullUrl));
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
    if (name == "Posted") {
      posts = post_store.posted;
    } else {
      posts = post_store.saved;
    }
    setState(() {
      isLoad = false;
    });
  }
  bool isLoadMore=false;
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
              ListView(
                controller: controller,
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
//                        Container(
//                          margin: EdgeInsets.only(left: 10),
//                          child: Row(
//                            children: <Widget>[
//                              Text(
//                                'Pictures',
//                                style: TextStyle(
//                                    fontSize: 15, fontFamily: 'Comfortaa'),
//                              ),
//                              IconButton(
//                                icon: Icon(
//                                  Icons.arrow_drop_down,
//                                  color: Colors.black,
//                                  size: 25,
//                                ),
//                                onPressed: () {},
//                              ),
//                            ],
//                          ),
//                        ),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 15, left: 10, right: 10, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        detail_user(user_store.currentUser.id);
                                      },
                                      child: Material(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.blue),
                                            ),
                                            width: width / 7,
                                            height: width / 7,
                                            padding: EdgeInsets.all(15.0),
                                          ),
                                          imageUrl:
                                               user_store.currentUser.picture,
                                          width: width / 5,
                                          height: width / 5,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(width / 10),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: width*2/5,
                                        margin: EdgeInsets.only(
                                            bottom: 10, right: 5),
                                        child: Observer(
                                          builder: (_) => Text(
                                            "${user_store.currentUser.name}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Comfortaa'),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: width / 1.8,
                                        margin: EdgeInsets.only(right: 5),
                                        child: Observer(
                                          builder: (_) => Text(
                                            "${user_store.currentUser.aboutMe != null ? user_store.currentUser.aboutMe : "About ${user_store.currentUser.name}"}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Comfortaa'),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: MyColors.darkButtonBackground,
                                  ),
                                  child: new RawMaterialButton(
                                    shape: new CircleBorder(),
                                    elevation: 0.0,
                                    child: new Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileScreen(
                                                )),
                                      );
                                    },
                                  ))
                            ],
                          ),
                        ),
                        Observer(
                          builder: (_) => DetailFollow(
                            posts:  post_store.posted.length.toString(),
                            following: user_store.currentUser.following.length
                                .toString(),
                            follows: user_store.currentUser.follower.length
                                .toString(),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: width,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              Container(
                                width: width * 7 / 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    _renderScreenButton(
                                        'Posted',
                                        pageChoosed == "Posted"
                                            ? MyColors.redButtonBackground
                                            : MyColors.clickedButtonBackground,
                                        () {
                                      chooseButton("Posted");
                                    }),
                                    _renderScreenButton(
                                        'Saved',
                                        pageChoosed == "Saved"
                                            ? MyColors.redButtonBackground
                                            : MyColors.clickedButtonBackground,
                                        () {
                                      chooseButton("Saved");
                                    }),
                                    new Container(),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLinearMode = !isLinearMode;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  width: width * 2 / 10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        child: Image.asset(
                                            isLinearMode
                                                ? 'assets/images/List.png'
                                                : 'assets/images/Grid.png',
                                            width: 20,
                                            height: 20,
                                            color: Colors.black),
                                      ),
                                      Icon(
                                        Icons.arrow_right,
                                        size: 20,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Observer(
                      builder: (_) => isLinearMode
                          ? _renderContentInLinearMode(context)
                          : _renderContentInGridMode(context)),
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
              onTap: () {
                //detail_user(store.post_profile[index].author.uid);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        //
                      },
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
                          imageUrl: pageChoosed == "Posted" ?(post_store.posted[index].author.picture ): (post_store.saved[index].author.picture),
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
                          child: Text( pageChoosed == "Posted" ?(post_store.posted[index].author.name ): (post_store.saved[index].author.name),
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
                                  DateTime.parse( pageChoosed == "Posted" ?(post_store.posted[index].createdAt ): (post_store.saved[index].createdAt))),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                  fontFamily: 'Comfortaa')),
                        )
                      ],
                    ),
                  ),
                  //follow(context, store.post_profile[index].author.uid),
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
                          imageUrl:  pageChoosed == "Posted" ?( server_url + "/" + post_store.posted[index].thumbUrl ): ( server_url + "/" + post_store.saved[index].thumbUrl),
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
                    "#${ pageChoosed == "Posted" ?(post_store.posted[index].tag ): (post_store.saved[index].tag)}",
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
                    pageChoosed == "Posted" ?(post_store.posted[index].title): (post_store.saved[index].title),
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
                          child:  (pageChoosed == "Posted" ?((post_store.posted[index].like.contains(user_store.currentUser.id))? Image.asset("assets/images/hearted.png",) : Image.asset("assets/images/heart.png",)): ((post_store.saved[index].like.contains(user_store.currentUser.id)))? Image.asset("assets/images/hearted.png",) : Image.asset("assets/images/heart.png",))
                        ),
                        Text(
                          pageChoosed == "Posted" ?(post_store.posted[index].like.length.toString()): (post_store.saved[index].like.length.toString()),
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
                          pageChoosed == "Posted" ?(post_store.posted[index].comment.length.toString()): (post_store.saved[index].comment.length.toString()),
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
//                 Container(
//                     width: width / 4.5,
//                     height: height / 20,
// //                    margin: const EdgeInsets.only(right: 10.0),
//                     padding: const EdgeInsets.only(
//                         top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
//                     decoration: new BoxDecoration(
//                       color: store.post_profile[index].save
//                           ? Colors.grey[350]
//                           : Color(0xffFF002F),
//                       border: Border.all(
//                         color: store.post_profile[index].save
//                             ? Colors.grey[350]
//                             : Color(0xffFF002F),
//                       ),
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                     ),
//                     child: FlatButton(
//                       splashColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       onPressed: () {
//                         savePost(index);
//                       },
//                       padding: EdgeInsets.all(0.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           Image.asset(
//                             "assets/images/save.png",
//                             width: width / 20,
//                             height: width / 20,
//                           ),
//                           Text(
//                             "${store.post_profile[index].save ? "Saved" : "Save"}",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12.0,
//                                 fontFamily: 'Comfortaa'),
//                           )
//                         ],
//                       ),
//                     )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _renderContentInLinearMode(context) {
    if (pageChoosed == "Posted" ?(post_store.posted.length > 0): (post_store.saved.length > 0)) {
      return Container(
        margin: const EdgeInsets.only(
          top: 10.0,
        ),
        child: Observer(
          builder: (_) => new ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: _buildAvatarItem,
            itemCount: pageChoosed == "Posted" ?(post_store.posted.length ): (post_store.saved.length),
          ),
        ),
      );
    } else {
      return Container(
          child: Center(
        child: Container(
          child: Text("There are currently no posts.",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Comfortaa', fontSize: 12)),
          margin: EdgeInsets.all(30),
        ),
      ));
    }
  }

  _renderContentInGridMode(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (pageChoosed == "Posted" ?(post_store.posted.length > 0): (post_store.saved.length > 0)) {
      return SafeArea(
        child: new Container(
          margin: EdgeInsets.only(left: 10.0, right: 10),
          child: Observer(
            builder: (_) => new StaggeredGridView.countBuilder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 4,
              itemCount: pageChoosed == "Posted" ?(post_store.posted.length): (post_store.saved.length),
              itemBuilder: (BuildContext context, int index) => new Container(
                child: GestureDetector(
                    onTap: () {
                      detail_post(index);
                    },
                    child: new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          width: width / 6,
                          height: width / 6,
                        ),
                        imageUrl: pageChoosed == "Posted" ? server_url + "/" + post_store.posted[index].thumbUrl: server_url + "/" + post_store.saved[index].thumbUrl,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 3 : 2),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
          ),
        ),
      );
    } else {
      return Container(
          child: Center(
        child: Container(
          child: Text(
              "There are currently no posts. ",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Comfortaa', fontSize: 12)),
          margin: EdgeInsets.all(30),
        ),
      ));
    }
  }

  _renderScreenButton(title, backgroundColor, callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
          margin: EdgeInsets.only(left: 10),
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

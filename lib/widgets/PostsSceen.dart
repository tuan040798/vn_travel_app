//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:intl/intl.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:vn_travel_app/model/post_infor.dart';
//import 'package:vn_travel_app/features/post_detail/post_detail_view.dart';
//import 'package:esys_flutter_share/esys_flutter_share.dart';
//import 'dart:io';
//import 'dart:async';
//import 'dart:typed_data';
//import 'package:flutter/services.dart';
//import 'package:flutter/foundation.dart';
//import 'package:vn_travel_app/stores/posts_store.dart';
//import 'package:flutter_mobx/flutter_mobx.dart';
//import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//
//class MyPosts extends StatefulWidget {
//  final String currentUserId;
//
//  MyPosts({Key key, @required this.currentUserId }) : super(key: key);
//
//  @override
//  State<StatefulWidget> createState() {
//    return MyPostsState(currentUserId: currentUserId);
//  }
//}
//
//class MyPostsState extends State<MyPosts> {
//  final String currentUserId;
//  final databaseReference = FirebaseDatabase.instance.reference();
//  bool render = false;
//
//  MyPostsState({Key key, @required this.currentUserId});
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  Widget follow(BuildContext context, String id) {
//    double width = MediaQuery.of(context).size.width;
//    double height = MediaQuery.of(context).size.height;
//    if (id == currentUserId) {
//      return new Container();
//    } else {
//      return Container(
//        width: width / 3.5,
//        height: height / 23,
//        margin: const EdgeInsets.only(right: 10.0),
//        decoration: new BoxDecoration(
//          color: Colors.grey[350],
//          border: Border.all(
//            color: Colors.grey[350],
//          ),
//          borderRadius: BorderRadius.all(Radius.circular(30.0)),
//        ),
//        child: FlatButton(
//          splashColor: Colors.transparent,
//          highlightColor: Colors.transparent,
//          padding: const EdgeInsets.only(
//              left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
//          onPressed: null,
//          child: new Text("Following",
//              style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa')),
//        ),
//      );
//    }
//  }
//
//  void detail_post(int index) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) => PostDetail(
//            currentUserId: currentUserId,
//            index: index,
//          )),
//    );
//  }
//
//  void detail_user() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) => EditProfileScreen(
//            currentUserId: currentUserId,
//          )),
//    );
//  }
//
//  Future likePost(int index) async {
//    DataSnapshot snapshot = await databaseReference
//        .child("likes")
//        .child(store.posts[index].id)
//        .once();
//    String curenttime = DateTime.now().millisecondsSinceEpoch.toString();
//    if (snapshot.value != null) {
//      if (snapshot.value[currentUserId] != null) {
//        await databaseReference
//            .child("likes")
//            .child(store.posts[index].id)
//            .child(currentUserId)
//            .remove();
//        await databaseReference
//            .child("likes")
//            .child(store.posts[index].id)
//            .once()
//            .then((DataSnapshot data) {
//          if (data.value != null) {
//            store.likePost(index, data.value.length);
//            setState(() {
//              render = !render;
//            });
//          } else {
//            store.likePost(index, 0);
//            setState(() {
//              render = !render;
//            });
//          }
//        });
//      } else {
//        await databaseReference
//            .child("likes")
//            .child(store.posts[index].id)
//            .set({currentUserId: curenttime});
//        await databaseReference
//            .child("likes")
//            .child(store.posts[index].id)
//            .once()
//            .then((DataSnapshot data) {
//          if (data.value != null) {
//            store.likePost(index, data.value.length);
//            setState(() {
//              render = !render;
//            });
//          } else {
//            store.likePost(index, 0);
//            setState(() {
//              render = !render;
//            });
//          }
//        });
//      }
//    } else {
//      await databaseReference.child("likes").set({
//        store.posts[index].id: {currentUserId: curenttime}
//      });
//      DataSnapshot data = await databaseReference
//          .child("likes")
//          .child(store.posts[index].id)
//          .once();
//      if (data.value != null) {
//        store.likePost(index, data.value.length);
//        setState(() {
//          render = !render;
//        });
//      } else {
//        store.likePost(index, 0);
//        setState(() {
//          render = !render;
//        });
//      }
//    }
//  }
//
//  Future<void> _shareImageFromUrl(String file) async {
//    try {
//      var request = await HttpClient().getUrl(Uri.parse(file));
//      var response = await request.close();
//      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//      await Share.file('BTS Social', 'image.jpg', bytes, 'image/jpg');
//    } catch (e) {
//      print('error: $e');
//    }
//  }
//
//  Future sharePost(int index) async {
//    try {
//      await _shareImageFromUrl(store.posts[index].full);
//      DataSnapshot snapshot = await databaseReference
//          .child("shares")
//          .child(store.posts[index].id)
//          .once();
//      String curenttime = DateTime.now().millisecondsSinceEpoch.toString();
//      if (snapshot.value != null) {
//        if (snapshot.value[currentUserId] != null) {
//          await databaseReference
//              .child("shares")
//              .child(store.posts[index].id)
//              .child(currentUserId)
//              .remove();
//          await databaseReference
//              .child("shares")
//              .child(store.posts[index].id)
//              .once()
//              .then((DataSnapshot data) {
//            if (data.value != null) {
//              store.sharePost(index, data.value.length);
//              setState(() {
//                render = !render;
//              });
//            } else {
//              store.sharePost(index, 0);
//              setState(() {
//                render = !render;
//              });
//            }
//          });
//        } else {
//          await databaseReference
//              .child("shares")
//              .child(store.posts[index].id)
//              .set({currentUserId: curenttime});
//          await databaseReference
//              .child("shares")
//              .child(store.posts[index].id)
//              .once()
//              .then((DataSnapshot data) {
//            if (data.value != null) {
//              store.sharePost(index, data.value.length);
//              setState(() {
//                render = !render;
//              });
//            } else {
//              store.sharePost(index, 0);
//              setState(() {
//                render = !render;
//              });
//            }
//          });
//        }
//      } else {
//        await databaseReference.child("shares").set({
//          store.posts[index].id: {currentUserId: curenttime}
//        });
//        DataSnapshot data = await databaseReference
//            .child("shares")
//            .child(store.posts[index].id)
//            .once();
//        if (data.value != null) {
//          store.sharePost(index, data.value.length);
//          setState(() {
//            render = !render;
//          });
//        } else {
//          store.sharePost(index, 0);
//          setState(() {
//            render = !render;
//          });
//        }
//      }
//    } catch (e) {
//      print('error: $e');
//    }
//  }
//
//  Widget _buildAvatarItem(BuildContext context, int index) {
//    // print("-------------------" +)
//    double width = MediaQuery.of(context).size.width;
//    double height = MediaQuery.of(context).size.height;
//    return SafeArea(
//      child: Container(
//        padding: const EdgeInsets.only(bottom: 25.0, top: 15.0),
//        decoration: new BoxDecoration(
//          color: Colors.white,
//          border: Border(
//            top: BorderSide(width: 0.5, color: Colors.grey[350]),
//          ),
//        ),
//        child: Column(
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                new Container(
//                  margin: const EdgeInsets.only(right: 10.0, left: 10.0),
//                  child: GestureDetector(
//                    onTap: detail_user,
//                    child: Material(
//                      child: CachedNetworkImage(
//                        placeholder: (context, url) => Container(
//                          child: CircularProgressIndicator(
//                            strokeWidth: 1.0,
//                            valueColor:
//                            AlwaysStoppedAnimation<Color>(Colors.blue),
//                          ),
//                          width: width / 7,
//                          height: width / 7,
//                          padding: EdgeInsets.all(15.0),
//                        ),
//                        imageUrl: store.posts[index].author.profilePicture,
//                        width: width / 7,
//                        height: width / 7,
//                        fit: BoxFit.cover,
//                      ),
//                      borderRadius: BorderRadius.all(
//                        Radius.circular(width / 14),
//                      ),
//                      clipBehavior: Clip.hardEdge,
//                    ),
//                  ),
//                ),
//                Expanded(
//                  flex: 1,
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    // mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Container(
//                        child: Text(store.posts[index].author.fullName,
//                            maxLines: 1,
//                            overflow: TextOverflow.ellipsis,
//                            style: TextStyle(
//                                color: Colors.black,
//                                fontFamily: 'Comfortaa',
//                                fontWeight: FontWeight.bold)),
//                      ),
//                      Container(
//                        child: Text(
//                            DateFormat('dd MMM kk:mm').format(
//                                DateTime.fromMillisecondsSinceEpoch(
//                                    int.parse(store.posts[index].timestamp))),
//                            style: TextStyle(
//                                color: Colors.black54,
//                                fontSize: 12.0,
//                                fontFamily: 'Comfortaa')),
//                      )
//                    ],
//                  ),
//                ),
//                follow(context, store.posts[index].author.uid),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Container(
//                    width: width,
//                    height: width * 1628 / 1500,
//                    margin: const EdgeInsets.only(top: 15.0),
//                    child: new FlatButton(
//                        padding: EdgeInsets.all(0.0),
//                        splashColor: Colors.transparent,
//                        highlightColor: Colors.transparent,
//                        onPressed: () {
//                          detail_post(index);
//                        },
//                        child: CachedNetworkImage(
//                          placeholder: (context, url) => Container(
//                            child: CircularProgressIndicator(
//                              strokeWidth: 1.0,
//                              valueColor: AlwaysStoppedAnimation<Color>(
//                                  Colors.blue),
//                            ),
//                            width: width / 7,
//                            height: width / 7,
//                            padding: EdgeInsets.all(15.0),
//                          ),
//                          imageUrl: store.posts[index].thumb,
//                          width: width,
//                          height: width,
//                          fit: BoxFit.cover,
//                        ))),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Container(
//                  width: width,
//                  padding:
//                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
//                  child: Text(
//                    store.posts[index].title,
//                    style:
//                    TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
//                    maxLines: 2,
//                    overflow: TextOverflow.ellipsis,
//                  ),
//                )
//              ],
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Container(
//                  width: width / 5.5,
//                  margin: const EdgeInsets.only(left: 10.0),
//                  child: FlatButton(
//                    splashColor: Colors.transparent,
//                    highlightColor: Colors.transparent,
//                    onPressed: () {
//                      likePost(index);
//                    },
//                    padding: EdgeInsets.all(0.0),
//                    child: Row(
//                      children: <Widget>[
//                        Container(
//                          width: width / 30,
//                          height: width / 30,
//                          margin: const EdgeInsets.only(right: 5.0),
//                          child: Image.asset(
//                            "assets/images/heart.png",
//                          ),
//                        ),
//                        Text(
//                          store.posts[index].like.toString(),
//                          style: TextStyle(
//                              color: Colors.grey,
//                              fontSize: 12,
//                              fontFamily: 'Comfortaa'),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                Container(
//                  width: width / 5.5,
//                  child: FlatButton(
//                    onPressed: () {
//                      detail_post(index);
//                    },
//                    splashColor: Colors.transparent,
//                    highlightColor: Colors.transparent,
//                    padding: EdgeInsets.all(0.0),
//                    child: Row(
//                      children: <Widget>[
//                        Container(
//                          width: width / 30,
//                          height: width / 30,
//                          margin: const EdgeInsets.only(right: 5.0),
//                          child: Image.asset(
//                            "assets/images/chat.png",
//                          ),
//                        ),
//                        Text(
//                          store.posts[index].comment.toString(),
//                          style: TextStyle(
//                              color: Colors.grey,
//                              fontSize: 12,
//                              fontFamily: 'Comfortaa'),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                Container(
//                  width: width / 5.5,
//                  child: FlatButton(
//                    splashColor: Colors.transparent,
//                    highlightColor: Colors.transparent,
//                    onPressed: () {
//                      sharePost(index);
//                    },
//                    padding: EdgeInsets.all(0.0),
//                    child: Row(
//                      children: <Widget>[
//                        Container(
//                          width: width / 30,
//                          height: width / 30,
//                          margin: const EdgeInsets.only(right: 5.0),
//                          child: Image.asset(
//                            "assets/images/share.png",
//                          ),
//                        ),
//                        Text(
//                          store.posts[index].share.toString(),
//                          style: TextStyle(
//                              color: Colors.grey,
//                              fontSize: 12,
//                              fontFamily: 'Comfortaa'),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                Container(
//                    width: width / 5,
//                    height: height / 20,
//                    margin: const EdgeInsets.only(right: 10.0),
//                    padding: const EdgeInsets.only(
//                        top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
//                    decoration: new BoxDecoration(
//                      color: Color(0xffFF002F),
//                      border: Border.all(
//                        color: Color(0xffFF002F),
//                      ),
//                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                    ),
//                    child: FlatButton(
//                      splashColor: Colors.transparent,
//                      highlightColor: Colors.transparent,
//                      onPressed: null,
//                      padding: EdgeInsets.all(0.0),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                        children: <Widget>[
//                          Image.asset(
//                            "assets/images/save.png",
//                            width: width / 20,
//                            height: width / 20,
//                          ),
//                          Text(
//                            "Save",
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 12.0,
//                                fontFamily: 'Comfortaa'),
//                          )
//                        ],
//                      ),
//                    )),
//              ],
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget buildItemGriedView (BuildContext context) {
//    double width = MediaQuery.of(context).size.width;
//    double height = MediaQuery.of(context).size.height;
//    return SafeArea(
//      child: new Container(
//        margin: EdgeInsets.only(left: 10.0, right: 10),
//        child: Observer(
//          builder: (_) => new StaggeredGridView.countBuilder(
//            physics: ScrollPhysics(),
//            shrinkWrap: true,
//            crossAxisCount: 4,
//            itemCount: store.all_posts.length,
//            itemBuilder: (BuildContext context, int index) =>
//            new Container(
//              child: GestureDetector(
//                  onTap: () {
//                    detail_post(index);
//                  },
//                  child: new ClipRRect(
//                    borderRadius:
//                    BorderRadius.all(Radius.circular(10)),
//                    child: CachedNetworkImage(
//                      placeholder: (context, url) => Container(
//                        child: Center(
//                          child: CircularProgressIndicator(
//                            strokeWidth: 1.0,
//                            valueColor:
//                            AlwaysStoppedAnimation<Color>(
//                                Colors.blue),
//                          ),
//                        ),
//                        width: width / 6,
//                        height: width / 6,
//                      ),
//                      imageUrl: store.all_posts[index].thumb,
//                      fit: BoxFit.fill,
//                    ),
//                  )),
//            ),
//            staggeredTileBuilder: (int index) =>
//            new StaggeredTile.count(2, index.isEven ? 3 : 2),
//            mainAxisSpacing: 10.0,
//            crossAxisSpacing: 10.0,
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget type_render(BuildContext context) {
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    double width = MediaQuery.of(context).size.width;
//    double height = MediaQuery.of(context).size.height;
//    print("render post: ${store.posts.length}");
//    if (store.posts.length > 0) {
//      return Container(
//        margin: const EdgeInsets.only(
//          top: 10.0,
//        ),
//        child: new ListView.builder(
//          physics: ScrollPhysics(),
//          shrinkWrap: true,
//          scrollDirection: Axis.vertical,
//          itemBuilder: _buildAvatarItem,
//          itemCount: store.posts.length,
//        ),
//      );
//    } else {
//      return Container(
//          child: Center(
//            child: Container(
//              child: Text(
//                  "Hiện tại chưa có bài đăng nào. Hãy theo dõi mọi người hoặc đăng bài mới.",
//                  style: TextStyle(
//                      color: Colors.black, fontFamily: 'Comfortaa', fontSize: 12)),
//              margin: EdgeInsets.all(30),
//            ),
//          ));
//    }
//  }
//}
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vn_travel_app/features/other_profile/other_profile.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';
import 'package:vn_travel_app/model/user_login.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';

// Notification
class FollowAll extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FollowAllState();
  }
}

class FollowAllState extends State<FollowAll> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    listfollow=[]..addAll(post_store.follows);
  }
  ScrollController controller;

  void detail_user(String userid) {
//    if (userid == store.currentUserId) {
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => EditProfileScreen(
//              currentUserId: userid,
//            )),
//      );
//    } else {
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => OtherProfile(
//              otherId: userid,
//            )),
//      );
//    }
  }

  bool isLoad = false;
  bool renderScreen = false;
  List<User> listfollow ;
  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
//      store.loadMore();
//      store.getPosts();startLoader();
      startLoader();
      print("last");
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
    post_store.changePageFollow(post_store.pageFollow+1);
    setState(() {

      fetchData();
    });
  }
  fetchData() async {
    if (this.mounted) {
      setState(() {
        isLoadMore = true;
      });
    }
    if(user_store.currentUser.following.length>0){
      var childUsers = await getListUserFollow(user_store.currentUser.id,
          user_store.currentUser.following.join(","), user_store.token,post_store.pageFollow);
      if(childUsers!=null){
        var users = childUsers['rows'];
        if (users != null && users.length > 0) {
          List<User> newListUser = new List<User>();
          users.forEach((item) {
            User cmtRes = User.fromJson(item);
            if (cmtRes.id != null) {
              newListUser.add(cmtRes);
            }
          });
          List<User> follows=[]..addAll(post_store.follows);
          follows..addAll(newListUser);
          listfollow..addAll(newListUser);
          post_store.setFollows(follows);

        }
      }

    }
    if (this.mounted) {
      setState(() {
        isLoadMore = false;
      });
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
    setState(() {
      renderScreen = !renderScreen;
    });
    post_store.getListFollow();
    post_store.getPost(user_store.currentUser.following);
  }
  bool isLoadMore=false;
  @override
  Widget build(BuildContext context) {
    print("Users ${user_store.currentUser.following.length}");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      body: SafeArea(
          child: Stack(
            children: <Widget>[
              new ListView(
                controller: controller,
                shrinkWrap: true,
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
                            onPressed: () {

                              Navigator.pop(context);

                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            padding: EdgeInsets.all(0.0),
                            child: Image.asset("assets/images/arrow_back.png"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              child: Text("Following",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'Comfortaa',
                                      fontWeight: FontWeight.bold))),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              detail_user(user_store.currentUser.id);
                            },
                            child: Material(
                              child: Observer(
                                builder: (_) => CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                    ),
                                    width: width / 7.5,
                                    height: width / 7.5,
                                  ),
                                  imageUrl: user_store.currentUser.picture,
                                  width: width / 7.5,
                                  height: width / 7.5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(width / 15),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      style: TextStyle(fontFamily: 'Comfortaa', fontSize: 12),
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
                  // list account
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Observer(
                        builder: (_) => post_store.follows.length > 0
                            ? new ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
//                    return new FollowItems(index: index,);
                            return _buildAccountItem(context, index);
                          },
                          itemCount: listfollow.length,
                        )
                            : new Container(
                          width: width,
                          height: width,
                          child: new Center(
                            child: new Text(
                              "List is empty.",
                              style: TextStyle(fontFamily: 'Comfortaa'),
                            ),
                          ),
                        )),
                  ),
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

  Widget _buildAccountItem(BuildContext context, int index) {
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
                  detail_user(listfollow[index].id);
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
                    ),
                    imageUrl: listfollow[index].picture,
                    width: width / 7,
                    height: width / 7,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(width / 10),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  listfollow[index].name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              width: width / 4,
              height: height / 20,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: user_store.currentUser.following
                  .contains(listfollow[index].id)
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
                  followUser(listfollow[index].id, index);
                },
                child: new Text(
                  user_store.currentUser.following
                      .contains(listfollow[index].id)
                      ? "Unfollow"
                      : "Follow",
                  style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

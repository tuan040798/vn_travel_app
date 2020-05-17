import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/features/post_detail/post_detail_view.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:vn_travel_app/features/search/search_view.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';

class BTS_Member {
  String name;
  bool isChoosed;

  BTS_Member({this.name, this.isChoosed});

  BTS_Member.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isChoosed = json['isChoosed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['isChoosed'] = this.isChoosed;
    return data;
  }
}

class Home extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  String name="";
  bool isLoading = false;
  bool isLoadingFilter = false;
  ScrollController controller;
//    List<Post> allPost;
  int quantity;
  int filterIndex;
  @override
  void initState() {
    super.initState();

//    allPost = new List<Post>();
//    allPost =[]..addAll(post_store.allHomePost);
    quantity = 1;
    filterIndex=0;
    controller = new ScrollController()..addListener(_scrollListener);
    listBTS = [
      new BTS_Member(name: "All", isChoosed: true),
      new BTS_Member(name: "Reviews", isChoosed: false),
      new BTS_Member(name: "Question", isChoosed: false),
      new BTS_Member(name: "Share", isChoosed: false),
      new BTS_Member(name: "Relax", isChoosed: false),
      new BTS_Member(name: "Tips", isChoosed: false),
      new BTS_Member(name: "Disscusion", isChoosed: false),
      new BTS_Member(name: "News", isChoosed: false),
    ];

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

  fetchData() async {
    if (this.mounted){
      setState((){
        isLoadMore=true;
      });
    }

    var res=await getAllPostByTag(quantity, user_store.token,name);


    if(res!=null){
      var respond = res["rows"];
      if (respond != null && respond.length > 0) {
        List<Post> newPostAll = new List<Post>();
        respond.forEach((item) {
          Post postRes = Post.fromJson(item);
          if (postRes.id != null) {
            newPostAll.add(postRes);
          }
        });
        List<Post> list;
        list=[]..addAll(post_store.allHomePost);
        list.addAll(newPostAll);
        post_store.setHomePost(list);
        setState(() {
          isLoading = false;
        });
      }

    }
    if (this.mounted){
      setState((){
        isLoadMore=false;
      });
    }

  }

  List<BTS_Member> listBTS;

  void _onFocusChange() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }

  Future chooseBoards(String data, int index) async {

    setState((){
      isLoadingFilter=true;
    });
//    List<Post> allPost;
    if (!listBTS[index].isChoosed) {
      for (int i = 0; i < listBTS.length; i++) {
        if (index == i) {
          setState(() {
            listBTS[i].isChoosed = !listBTS[i].isChoosed;
          });
        } else {
          setState(() {
            listBTS[i].isChoosed = false;
          });
        }
      }

    }
    if (listBTS[index].isChoosed) {
//        await post_store.getHomePost();

//      await post_store.getHomePostByTag(data);

      if (index == 0) {
        await post_store.getHomePost();
//        allPost = []..addAll(post_store.allHomePost);
      } else {
        await post_store.getHomePostByTag(data);
//        allPost=new List<Post>();
//        await post_store.getHomePost();
//        for (int i = 0; i < post_store.allHomePost.length; i++) {
//
//          if (post_store.allHomePost[i].tag.contains(data)) {
//              allPost.add(post_store.allHomePost[i]);
//          }
//        }
      }
    }

    setState((){
      isLoadingFilter=false;
    });


  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshPost() async {

//    if(filterIndex==0){
//      setState(() {
//
//        allPost =[]..addAll(post_store.allHomePost) ;
//        quantity = 1;
//      });
      await post_store.getHomePostByTag(name);
//    }else{
//
//      chooseBoards(listBTS[filterIndex].name, filterIndex);
//    }


  }

  Future<Null> _refresh() {
    return refreshPost();
  }

  Widget buildItem(BuildContext context, int index) {
    return new Container(
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: listBTS[index].isChoosed ? Colors.redAccent : Colors.grey[350],
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: new FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              filterIndex=index;
              chooseBoards(listBTS[index].name, index);
              name=listBTS[index].name;
            },
            child: new Text(
              listBTS[index].name,
              style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa'),
            )));
  }

  void detail_post(int index) {

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostDetail(
                postDetail: post_store.allHomePost[index],index: index,
              )),
    );
  }

  void detail_user() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfileScreen(
              )),
    );
  }
  bool isLoadMore=false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // TODO: implement build
    return new Scaffold(
        body: new Observer(builder: (_)=>new Stack(
      children: <Widget>[
        RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: new ListView(
            controller: controller,
            scrollDirection: Axis.vertical,
            children: <Widget>[
//                new Container(
//                  child: Padding(
//                    padding: const EdgeInsets.only(left: 20.0),
//                    child: new Row(
//                      children: <Widget>[
//                        new Text(
//                          "Pictures",
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 20,
//                            fontFamily: 'Comfortaa',
//                          ),
//                        ),
//                        new Container(
//                            padding: EdgeInsets.all(0.0),
//                            //onPressed: null,
//                            width: 30.0,
//                            child: FlatButton(
//                              onPressed: () => {
//
//                              },
//                              padding: EdgeInsets.all(0.0),
//                              child: new Icon(
//                                Icons.arrow_drop_down,
//                                size: 30,
//                                color: Colors.black,
//                              ),
//                            )),
//                      ],
//                    ),
//                  ),
//                ),
              new Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width - width / 4.5,
                      height: ((width - width / 4.5) * 46) / 292,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/searchBox.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: new TextField(
                        onTap: () {
                          _onFocusChange();
                        },
                        //focusNode: _focus,
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
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onChanged: (text) {
                          //
                        },
                      ),
                    ),
                    new Container(
                      child: user_store.currentUser.picture != null
                          ? GestureDetector(
                        onTap: detail_user,
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
                      )
                          : Container(
                        width: width / 7.2,
                        height: width / 7.2,
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 30,
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildItem(context, index),
                  itemCount: listBTS.length,
                ),
              ),
              Observer(
                builder: (_) => checkData(context),
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
        ),
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        ),
      ],
    )));
  }

  Widget checkData(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (post_store.allHomePost.length > 0) {
      return new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10),
        child: Observer(
          builder: (_) =>isLoadingFilter?Container(
            width: width,
            height: height/2,
            child: new Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
              ),
            ),
          ): new StaggeredGridView.countBuilder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            itemCount: post_store.allHomePost.length,
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
                      imageUrl: server_url + "/" + post_store.allHomePost[index].thumbUrl,
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
}

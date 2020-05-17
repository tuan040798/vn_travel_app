import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vn_travel_app/features/profile_edit/profile_edit_view.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vn_travel_app/features/search/search_view.dart';
import 'package:vn_travel_app/model/news.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
import 'News_webview.dart';
import 'package:vn_travel_app/utils/rest_api/news_api.dart';
import 'package:vn_travel_app/model/news.dart';

class Notice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoticeState();
  }
}

class NoticeState extends State<Notice> {
  List<NewsModal> news;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    news = new List<NewsModal>();
    news = post_store.news;
  }

  Widget _buildNoticeItem(BuildContext context, int index) {
    // print("-------------------" +)
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: post_store.news[index].link,
              )),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              height: height / 2,
              width: width - 30,
              child: FadeInImage(
                image: NetworkImage(post_store.news[index].imgUrl),
                fit: BoxFit.cover,
                placeholder: new AssetImage("assets/images/load.gif"),
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                color: Colors.red[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.red[100],
                    blurRadius: 10.0, // has the effect of softening the shadow
                    spreadRadius: 1.0, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      1.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              // margin: EdgeInsets.only(top: 10.0),
              width: width - 30,
              padding: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 25.0, right: 10.0),
              child: Text(
                post_store.news[index].title,
//                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'ComfortaaBold'),
              ),
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
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: _buildNoticeItem,
        itemCount: post_store.news.length,
      ),
    );
  }
}

// Notification
class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificatioState();
  }
}

class NotificatioState extends State<NotificationScreen> {
  ScrollController controller=new ScrollController();
  bool render=false;
  int quantity;
  void detail_user() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfileScreen(
          )),
    );
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      startLoader();
      print("last");
    }
//    if (controller.position.pixels == controller.position.minScrollExtent) {
//      post_store.getHomePost();
//    }
  }
  void fetchdata() async{
    if (this.mounted) {
      setState(() {
        isLoadMore = true;
      });
    }
    var childCmtRes = await getAllNews(user_store.token,quantity);
    if (childCmtRes != null && childCmtRes.length > 0) {
      List<NewsModal> newListCommet = new List<NewsModal>();
      childCmtRes.forEach((item) {
        NewsModal cmtRes = NewsModal.fromJson(item);
        if (cmtRes.id != null) {
          newListCommet.add(cmtRes);
        }
      });
      List<NewsModal> list=new List<NewsModal>();
      list=[]..addAll(post_store.news);
      list..addAll(newListCommet);
      post_store.setNews(list) ;

      print("All Sub Comment: ${post_store.news.length}");
      setState(() {
        render=!render;
      });
    }
    if (this.mounted) {
      setState(() {
        isLoadMore = false;
      });
    }
  }
  void startLoader(){
    quantity+=1;
    fetchdata();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    quantity=1;
  }
  bool isLoadMore=false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      body: SafeArea(
        child: new ListView(
          controller: controller,
          children: <Widget>[
            new Column(
              children: <Widget>[
                // search box
//                new Container(
//                  child: Image.asset("assets/images/btsnew.png"),
//                ),
                Notice(),
                isLoadMore?Container(
                    height: height/10,
                    child:new Center(
                      child:  CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),

                      ),
                    )
                ):Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}

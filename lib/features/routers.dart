import 'package:flutter/material.dart';
import 'package:vn_travel_app/features/home/home_view.dart';
import 'package:vn_travel_app/features/follow/follow_view.dart';
import 'package:vn_travel_app/features/notification/notification_view.dart';
import 'package:vn_travel_app/features/profile/profile_view.dart';
import 'package:vn_travel_app/utils/fab_bottom_app_bar.dart';
import 'package:vn_travel_app/utils/fab_with_icons.dart';
import 'package:vn_travel_app/utils/layout.dart';
import 'package:vn_travel_app/features/create_post/create_post_view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vn_travel_app/features/new_post/new_post_view.dart';
import 'package:vn_travel_app/features/home_chat/home_chat_view.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
class Router extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RouterState();
  }
}

class RouterState extends State<Router> with TickerProviderStateMixin {
  File _image;
  bool reRender = false;
  void callback(){
    setState(() {
      reRender=!reRender;
    });
  }
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      if(_image != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewPost(image: image,callback:callback)));
      } else {
        Fluttertoast.showToast(msg: 'Vui lòng chọn ảnh!');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    post_store.getPosted();
    post_store.getSaveds();
    post_store.getNews();
    post_store.getListFollow();


  }

  void loadData() async {

    await post_store.getPost(user_store.currentUser.following);
    if(post_store.allHomePost.length == 0){
      await post_store.getHomePost();
    }
    setState(() {
      reRender = !reRender;
    });
  }

  int _selectedIndex = 0;


  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Widget render(BuildContext context,int index){
    switch(index){
      case 0: {
        return Home();
//        return post_store.allHomePost.length > 0 ? Home(currentUserId: currentUserId) : Container(
//          child:new Center(
//            child:  CircularProgressIndicator(
//              valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
//
//            ),
//          )
//        );
      }
      case 1: {
         return  FollowScreen();
      }
      case 2: {
        return NotificationScreen();
      }
      case 3: {
        return Profile();
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Scaffold(

      body: WillPopScope(
          child: new SafeArea(
              child: Stack(
                children: <Widget>[
                  render(context, _selectedIndex),
//              Align(
//                alignment: Alignment.bottomRight,
//                child: Container(
//                  margin: EdgeInsets.only(bottom: 10, right: 10),
//                  child:
//                  FloatingActionButton(
//                    backgroundColor: Colors.transparent,
//                    onPressed: (){
//                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen()));
//                    },
//                    child: Image.asset("assets/images/ic_chat.png", fit: BoxFit.fill,),
//                    heroTag: null,
//                    tooltip: 'Chat',
//                  ),
//                )
//              ),

                ],
              )
          ),
          onWillPop: (){
            exit(0);
//            Navigator.pop(context, 1);
          }
      ),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: '',
        color: Colors.grey,
        selectedColor: Colors.red,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: ''),
          FABBottomAppBarItem(iconData: Icons.people, text: ''),
          FABBottomAppBarItem(iconData: Icons.notifications, text: ''),
          FABBottomAppBarItem(iconData: Icons.person, text: ''),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          getImage();
          //Navigator.push(context, MaterialPageRoute(builder: (context)=> CreatePost(currentUserId: currentUserId,)));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
        heroTag: null
      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: _buildFab(
//          context),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [ Icons.sms, Icons.mail, Icons.phone ];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {
          print("Hello");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

}

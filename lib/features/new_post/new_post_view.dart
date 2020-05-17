import 'package:flutter/material.dart';
import 'dart:io';
import 'package:vn_travel_app/features/choose_board/choose_board_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewPost extends StatefulWidget{

  File image;
  Function callback;

  NewPost({Key key, @required this.image, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new NewPostState(image: image);
  }
}

class NewPostState extends State<NewPost> {

  final File image;
  String title;
  String description="";

  NewPostState({Key key, @required this.image});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: new Text("New Post", style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),),
        leading: new FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: new Icon(Icons.arrow_back, color: Colors.black, size: 25,)
        ),
        actions: <Widget>[
          new FlatButton(
              onPressed: (){
                if(title != null){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> ChooseBoardScreen(image: image, title: title, description: description,callback:widget.callback))
                  );
                } else {
                  Fluttertoast.showToast(msg: 'Vui lòng nhập tiêu đề!');
                }
              },
              child: new Container(
                padding: EdgeInsets.only(top: 5,bottom: 5, right: 15, left: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.black,
                ),
                child: new Text("Next", style: TextStyle(color: Colors.white, fontFamily: 'Comfortaa'),),
              )
          )
        ],
      ),
      body: new SafeArea(
          child: new ListView(
            children: <Widget>[
              new Container(
                child: new Image.file(image, width: width,height: width,),
              ),
              new Container(
                width: width-10,
                height: (width-10)*0.2111,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage("assets/images/boxShadowPost.png"),
                  ),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Title", style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),),
                    new Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: new TextField(
                        style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
                        decoration: new InputDecoration(
                          hintText: "Write the title here",
                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Comfortaa'),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onChanged: (text) {
                          setState(() {
                            this.title = text;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                width: width-10,
                height: (width-10)*0.2111,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage("assets/images/boxShadowPost.png"),
                  ),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Description", style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),),
                    new Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: new TextField(
                        style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),
                        decoration: new InputDecoration(
                          hintText: "Write the description here",
                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Comfortaa'),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onChanged: (text) {
                          setState(() {
                            this.description = text;
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}
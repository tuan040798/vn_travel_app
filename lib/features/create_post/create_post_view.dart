import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vn_travel_app/features/new_post/new_post_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreatePost extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CreatePostState();
  }
}

class CreatePostState extends State<CreatePost> {

  File _image;

  CreatePostState({Key key});

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    if(_image != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewPost(image: image,)));
    } else {
      Fluttertoast.showToast(msg: 'Vui lòng chọn ảnh!');
    }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text("Create Post", style: TextStyle(color: Colors.black, fontFamily: 'Comfortaa'),),
        leading: new FlatButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: (){
              Navigator.pop(context);
            },
            child: new Icon(Icons.arrow_back, color: Colors.black, size: 25,)
        ),
      ),
      body: new SafeArea(
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: new Text("Lấy ảnh từ máy ảnh",
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Comfortaa'
                    ),
                  ),
                ),
                new FlatButton(
                    padding: EdgeInsets.all(0),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: getImage,
                    child: new Container(
                      padding: EdgeInsets.only(left: 25 ,right:  25, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(0xffFF002F),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: new Text("Go", style: TextStyle(color: Colors.white,fontSize: 20, fontFamily: 'Comfortaa'),),
                    )
                )
              ],
            ),
          ),
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
class DetailFollow extends StatelessWidget {
  const DetailFollow({Key key, this.posts, this.follows, this.following})
      : super(key: key);

  final posts, follows, following;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      posts.toString(),
                      style:
                      TextStyle(fontFamily: 'Comfortaa', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Posts',
                      style: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      follows,
                      style:
                      TextStyle(fontFamily: 'Comfortaa', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      following,
                      style:
                      TextStyle(fontFamily: 'Comfortaa', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Following',
                      style: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}

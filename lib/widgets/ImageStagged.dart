import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageStagged extends StatelessWidget {
  const ImageStagged({this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: InkWell(
        onTap: () {
          print('image clicked');
        },
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: Image.network(url, fit: BoxFit.contain,),
        )
      )
    );
  }
}
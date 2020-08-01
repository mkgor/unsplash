import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsplash/models/photo.dart';
import 'package:unsplash/screens/more.dart';
import 'package:unsplash/widgets/photo_image.dart';

class PhotoWidget extends StatelessWidget {
  final Photo photo;

  PhotoWidget({this.photo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MoreScreen(photo: photo)));
        },
        child: PhotoImage(url: photo.fullImageUrl));
  }
}

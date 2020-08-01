import 'package:flutter/material.dart';

class LikeWidget extends StatelessWidget {
  int likes;
  bool isLiked = false;

  LikeWidget({this.likes, this.isLiked = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          isLiked ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border),
          SizedBox(width: 5.0),
          Text(likes.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18))
        ],
      ),
    );
  }
}

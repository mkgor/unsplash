import 'package:flutter/material.dart';

class PhotoImage extends StatelessWidget {
  final url;

  PhotoImage({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: NetworkImage(url), fit: BoxFit.cover),

      ),
    );
  }
}

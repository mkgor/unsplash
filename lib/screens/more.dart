import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash/bloc/app_bloc.dart';
import 'package:unsplash/bloc/app_events.dart';
import 'package:unsplash/models/photo.dart';
import 'package:unsplash/widgets/like_widget.dart';
import 'package:unsplash/widgets/photo_image.dart';

class MoreScreen extends StatefulWidget {
  final Photo photo;

  MoreScreen({this.photo});

  @override
  State<StatefulWidget> createState() => _MoreScreenState();
}

class _MoreScreenState extends State {
  Photo photo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.photo = (widget as MoreScreen).photo;
  }

  void _setLike() {
    setState(() {
      photo = photo.copyWith(likedByUser: true, likes: photo.likes + 1);
    });
  }

  void _unsetLike() {
    setState(() {
      photo = photo.copyWith(likedByUser: false, likes: photo.likes - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.grey),
        actions: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Spacer(),
                Text(
                  "Photo",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Spacer()
              ],
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
              child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PhotoImage(url: photo.fullImageUrl),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: photo.description != null
                      ? Text(
                          photo.description,
                          style: TextStyle(color: Color.fromRGBO(178, 187, 198, 1), fontSize: 16),
                        )
                      : SizedBox.shrink(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: ClipRRect(borderRadius: BorderRadius.circular(100), child: Image.network(photo.user.profileImage)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.grey,
                                offset: new Offset(0, 2.0),
                                blurRadius: 6
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(photo.user.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                              Text("@${photo.user.username}", style: TextStyle(color: Color.fromRGBO(142, 142, 147, 1), fontSize: 15))
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!photo.likedByUser) {
                          BlocProvider.of<AppBloc>(context).add(LikeEvent(photoId: photo.id));

                          _setLike();
                        } else {
                          BlocProvider.of<AppBloc>(context).add(UnlikeEvent(photoId: photo.id));

                          _unsetLike();
                        }
                      },
                      child: LikeWidget(likes: photo.likes, isLiked: photo.likedByUser),
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

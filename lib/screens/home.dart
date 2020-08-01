import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash/bloc/app_bloc.dart';
import 'package:unsplash/bloc/app_events.dart';
import 'package:unsplash/bloc/app_states.dart';
import 'package:unsplash/widgets/like_widget.dart';
import 'package:unsplash/widgets/loader.dart';
import 'package:unsplash/widgets/photo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller;
  bool blockLoading = false;
  String query;

  @override
  Widget build(BuildContext context) {
    controller = ScrollController()
      ..addListener(() {
        if (controller.position.extentAfter < 300 && !blockLoading) {
          blockLoading = true;

          if (query == null || query == '') {
            BlocProvider.of<AppBloc>(context).add(FetchEvent());
          } else {
            BlocProvider.of<AppBloc>(context).add(FetchWithQueryEvent(query: query));
          }
        }
      });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              padding: EdgeInsets.all(0),
              width: 500,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Color.fromRGBO(225, 225, 228, 1)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.search,
                        color: Color.fromRGBO(205, 205, 208, 1),
                      )),
                  Expanded(
                    flex: 9,
                    child: TextField(
                      onSubmitted: (value) {
                        query = value;

                        if (value.isEmpty) {
                          BlocProvider.of<AppBloc>(context).add(FetchEvent(clearAll: true));
                        } else {
                          BlocProvider.of<AppBloc>(context).add(FetchWithQueryEvent(query: query));
                        }
                      },
                      decoration: InputDecoration(border: InputBorder.none, hintText: 'Search'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          BlocBuilder<AppBloc, AppState>(
            builder: (BuildContext context, AppState state) {
              print(state);
              if (state is AppUninitialized) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is AppError) {
                return Center(
                  child: Text('Unable to fetch photos'),
                );
              }
              if (state is AppLoaded) {
                if (state.photos.isEmpty) {
                  return Center(
                    child: Text('No photos'),
                  );
                }

                blockLoading = false;

                return Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return index >= state.photos.length
                                  ? BottomLoader()
                                  : Container(
                                      margin: index == 0 ? EdgeInsets.only(bottom: 10, left: 10, right: 10) : EdgeInsets.all(10.0),
                                      child: Stack(
                                        children: <Widget>[
                                          PhotoWidget(photo: state.photos[index]),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (!state.photos[index].likedByUser) {
                                                          BlocProvider.of<AppBloc>(context).add(LikeEvent(photoId: state.photos[index].id));
                                                        } else {
                                                          BlocProvider.of<AppBloc>(context).add(UnlikeEvent(photoId: state.photos[index].id));
                                                        }
                                                      },
                                                      child: LikeWidget(likes: state.photos[index].likes, isLiked: state.photos[index].likedByUser),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ));
                            },
                            itemCount: state.hasReachedMax ? state.photos.length : state.photos.length + 1,
                            controller: controller,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  AppEvent([List props = const []]);
}

class FetchEvent extends AppEvent {
  final bool initial;
  final bool clearAll;

  FetchEvent({this.initial = false, this.clearAll = false});

  @override
  List<Object> get props => [clearAll];

  //For debug
  @override
  String toString() => 'Fetch';
}

class FetchWithQueryEvent extends AppEvent {
  final bool initial;
  final String query;

  FetchWithQueryEvent({this.initial = false, this.query});

  @override
  List<Object> get props => [query];

  //For debug
  @override
  String toString() => 'FetchWithQuery';
}

class LikeEvent extends AppEvent {
  final String photoId;

  LikeEvent({this.photoId}) : super([photoId]);

  @override
  List<Object> get props => [photoId];

  @override
  String toString() => 'LikeEvent';
}

class UnlikeEvent extends AppEvent {
  final String photoId;

  UnlikeEvent({this.photoId});

  @override
  List<Object> get props => [photoId];

  @override
  String toString() => 'UnlikeEvent';
}


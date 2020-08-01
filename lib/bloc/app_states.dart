import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AppState extends Equatable {
  AppState([List props = const []]);
}

class AppUninitialized extends AppState {
  @override
  String toString() => 'AppUninitialized';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AppError extends AppState {
  @override
  String toString() => 'AppError';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AppLoaded extends AppState {
  final List photos;
  final bool hasReachedMax;
  final int page;
  final String query;

  AppLoaded({
    this.photos,
    this.hasReachedMax,
    this.page: 1,
    this.query
  }) : super([photos, hasReachedMax, page, query]);

  AppLoaded copyWith({
    List photos,
    bool hasReachedMax,
  }) {
    return AppLoaded(
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      query: query ?? this.query
    );
  }

  @override
  String toString() =>
      'AppLoaded { Apps: ${photos.length}, hasReachedMax: $hasReachedMax }';

  @override
  List<Object> get props => [photos, hasReachedMax, page, query];
}
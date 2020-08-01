import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:unsplash/models/user.dart';

@immutable
class Photo extends Equatable {
  final String id;
  final int likes;
  final bool likedByUser;
  final User user;
  final String description;
  final String fullImageUrl;

  Photo(
      {this.id,
      this.likes,
      this.likedByUser,
      this.user,
      this.description,
      this.fullImageUrl});

  @override
  List<Object> get props =>
      [id, likes, likedByUser, user, description, fullImageUrl];

  Photo copyWith({
    String id,
    int likes,
    bool likedByUser,
    User user,
    String description,
    String fullImageUrl
  }) {
    return Photo(
        id: id ?? this.id,
        likes: likes ?? this.likes,
        likedByUser: likedByUser ?? this.likedByUser,
        user: user ?? this.user,
        description: description ?? this.description,
        fullImageUrl: fullImageUrl ?? this.fullImageUrl
    );
  }

  Photo fromJson(Map<String, dynamic> json) {
    return Photo(
        id: json['id'],
        likes: json['likes'],
        likedByUser: json['liked_by_user'],
        user: User().fromJson(json['user']),
        description: json['description'],
        fullImageUrl: json['urls']['regular']);
  }
}

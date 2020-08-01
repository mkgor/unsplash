import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class User extends Equatable {
  final String id;
  final String username;
  final String name;
  final String profileImage;

  User({this.id, this.username, this.name, this.profileImage});

  User fromJson(Map<String, dynamic> json) {
    return User(
    id: json['id'],
    username: json['username'],
    name: json['name'],
    profileImage: json['profile_image']['medium']);
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, username, name, profileImage];
}

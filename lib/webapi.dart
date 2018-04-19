import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPost() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/posts');
  final List<dynamic> responseJson = json.decode(response.body);
  final List<Post> posts = new List<Post>();

  for (var i = 0; i == responseJson.length; i++) {
     posts.add(new Post.fromJson(responseJson[i]));
  }

  return posts;
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}


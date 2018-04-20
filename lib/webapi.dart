import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostApi {

  Future <List<Post>> getPosts({int offset: 0}) async {
    try {
      final response =
      await http.get('https://jsonplaceholder.typicode.com/posts');
      final List<dynamic> responseJson = json.decode(response.body);
      final List<Post> posts = responseJson.map((m) => new Post.fromJson(m)).toList();

      return posts;
    } catch (e) {
      throw new Exception(e.toString());
    }
  }

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


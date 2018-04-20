import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_get_started/webapi.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter get started!!',
      home: new PostsListWidget(),
    );
  }
}

class PostsListWidget extends StatefulWidget {
  @override
  createState() => new PostsListState();
}

class PostsListState extends State<PostsListWidget> {
  final _posts = <Post>[];
  final _savedPosts = new Set<Post>();
  final _postApi = new PostApi();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _postApi.getPosts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return _createListView(context, snapshot);
        }
      },
    );

    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: futureBuilder
      //body: _buildSuggestions(),
    );
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    this._posts.addAll(snapshot.data);

    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: this._posts.length,
//          itemExtent: 300.0,
        itemBuilder: (BuildContext context, int index) {
          Post post = this._posts[index];
          return _createListRow(post);
        });
  }

  Widget _createListRow(Post post) {
    final alreadySaved = _savedPosts.contains(post);
    return new ListTile(
      title: new Text(
        post.title,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedPosts.remove(post);
          } else {
            _savedPosts.add(post);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _savedPosts.map((post) {
              return new ListTile(
                title: new Text(
                  post.title,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Posts'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}
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
  final _biggerFont = const TextStyle(fontSize: 18.0);

  String _errorMessage = "";
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    this._loadPosts();
  }

  void _loadPosts() {
    new PostApi().getPosts().then((x) {
      setState(() {
        this._isError = false;
        this._posts.insertAll(this._posts.length, x);
      });
    }).catchError((e) {
      setState(() {
        this._isError = true;
        this._errorMessage = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this._isError) {
      return new Center(child: new Text(this._errorMessage),);
    }

    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: this._posts.length,
//          itemExtent: 300.0,
          itemBuilder: (BuildContext context, int index) {
            Post post = this._posts[index];
            return _createListRow(post);
          })
      //body: _buildSuggestions(),
    );
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
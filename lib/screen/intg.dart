import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cls.dart';

class Intg extends StatefulWidget {
  const Intg({Key? key}) : super(key: key);

  @override
  State<Intg> createState() => _IntgState();
}

class _IntgState extends State<Intg> {
  late Future<List<AlbumModel>> albums;

  @override
  void initState() {
    albums = fetchdata();
    super.initState();
  }

  Future<List<AlbumModel>> fetchdata() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<AlbumModel> albumsList =
          body.map((dynamic item) => AlbumModel.fromJson(item)).toList();
      return albumsList;
    } else {
      throw Exception("Failed to load data");
    }
  }

  void deleteAlbum(int index) {
    setState(() {
      albums = albums.then((list) {
        list.removeAt(index);
        return Future.value(list);
      });
    });
  }

  void editTitle(int index, String newTitle) {
    setState(() {
      albums = albums.then((list) {
        list[index].title = newTitle;
        return Future.value(list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Data"),
      ),
      body: Center(
        child: FutureBuilder<List<AlbumModel>>(
          future: albums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<AlbumModel> data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return AlbumListTile(
                    album: data[index],
                    onDelete: () => deleteAlbum(index),
                    onEdit: (newTitle) => editTitle(index, newTitle),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class AlbumListTile extends StatefulWidget {
  final AlbumModel album;
  final VoidCallback onDelete;
  final Function(String) onEdit;

  const AlbumListTile({
    required this.album,
    required this.onDelete,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  _AlbumListTileState createState() => _AlbumListTileState();
}

class _AlbumListTileState extends State<AlbumListTile> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.album.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void submitEdit() {
    widget.onEdit(_controller.text);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _isEditing
          ? TextFormField(
              controller: _controller,
              autofocus: true,
              onFieldSubmitted: (_) => submitEdit(),
            )
          : Text(widget.album.title),
      subtitle: Text("ID: ${widget.album.id}, UserID: ${widget.album.userId}"),
      trailing: Wrap(
        spacing: 12,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: widget.onDelete,
          ),
          _isEditing
              ? IconButton(
                  icon: Icon(Icons.done),
                  onPressed: submitEdit,
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: startEditing,
                ),
        ],
      ),
    );
  }
}

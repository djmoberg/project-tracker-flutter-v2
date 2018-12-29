import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/components/MySpinner.dart';
import 'package:project_tracker/utils/Prefs.dart';

class NewImage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyNewImage2();
  }
}

class MyNewImage2 extends StatefulWidget {
  @override
  _MyNewImage2State createState() => _MyNewImage2State();
}

class _MyNewImage2State extends State<MyNewImage2> {
  File _image;
  bool _loading = false;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future _getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check),
              onPressed: _image == null || _loading
                  ? null
                  : () async {
                      setState(() {
                        _loading = true;
                      });
                      bool success = await upload(
                          _image, Prefs().selectedProject.toString());
                      setState(() {
                        _loading = false;
                      });
                      if (success) Navigator.pop(context, true);
                    })
        ],
      ),
      body: Center(
        child: _loading
            ? loaderIndicator()
            : _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      bottomSheet: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              child: Text("Camera"),
              onPressed: _loading ? null : _getImage,
            ),
          ),
          Expanded(
            child: RaisedButton(
              child: Text("Gallery"),
              onPressed: _loading ? null : _getImageGallery,
            ),
          ),
        ],
      ),
    );
  }
}

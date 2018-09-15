import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/projectExplorer/images/NewImage2.dart';

class Images extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyImages();
  }
}

class MyImages extends StatefulWidget {
  @override
  _MyImagesState createState() => _MyImagesState();
}

class _MyImagesState extends State<MyImages> {
  List<dynamic> _imgLinks = List();

  _getImages() async {
    List<dynamic> res = await getImages();
    setState(() {
      _imgLinks = res;
    });
  }

  @override
  void initState() {
    super.initState();
    _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _imgLinks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: CachedNetworkImage(
              placeholder: Center(child: CircularProgressIndicator()),
              imageUrl: _imgLinks[index]["image_url"],
            ),
            // child: Image.network(_imgLinks[index]["image_url"]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () async {
          bool update = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewImage2()));
          if (update != null && update) _getImages();
        },
      ),
    );
  }
}

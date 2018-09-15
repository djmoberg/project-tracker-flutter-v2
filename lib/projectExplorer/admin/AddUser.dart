import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(suffixIcon: Icon(Icons.search)),
        ),
        RaisedButton(
          child: Text("Add"),
          onPressed: () {},
        ),
      ],
    );
  }
}

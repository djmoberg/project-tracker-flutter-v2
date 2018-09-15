import 'package:flutter/material.dart';

class UserOptionDialog extends StatelessWidget {
  final Map<String, dynamic> _user;

  UserOptionDialog(this._user);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Options: " + _user["name"]),
      children: <Widget>[
        !_user["isAdmin"]
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FlatButton(
                    child: Text("Make Admin"),
                    color: Theme.of(context).buttonColor,
                    onPressed: () => Navigator.pop(context, "admin")),
              )
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
              child: Text("Remove"),
              color: Colors.red,
              onPressed: () => Navigator.pop(context, "remove")),
        ),
      ],
    );
  }
}

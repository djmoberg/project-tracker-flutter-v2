import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/utils/Prefs.dart';

class ProjectDeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyProjectDeleteDialog();
  }
}

class MyProjectDeleteDialog extends StatefulWidget {
  @override
  _MyProjectDeleteDialogState createState() => _MyProjectDeleteDialogState();
}

class _MyProjectDeleteDialogState extends State<MyProjectDeleteDialog> {
  String _projectName = Prefs().projectName;
  String _input = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Project"),
      content: Container(
        height: 300.0,
        child: ListView(
          children: <Widget>[
            Text("The project will permanently be deleted\n"),
            Text("Are you sure you want to delete the project?\n"),
            Text("Please type in the name of the project (" +
                _projectName +
                ") to confirm\n"),
            TextField(
              onChanged: (value) {
                setState(() {
                  _input = value;
                });
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: _input != _projectName
              ? null
              : () {
                  deleteProject();
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
        ),
      ],
    );
  }
}

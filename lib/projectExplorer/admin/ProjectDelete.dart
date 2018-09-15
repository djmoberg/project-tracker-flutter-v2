import 'package:flutter/material.dart';

import 'package:project_tracker/projectExplorer/admin/ProjectDeleteDialog.dart';

class ProjectDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.red,
      child: Text("Delete"),
      onPressed: () {
        showDialog(
            context: context, builder: (context) => ProjectDeleteDialog());
      },
    );
  }
}

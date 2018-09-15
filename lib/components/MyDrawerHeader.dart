import 'package:flutter/material.dart';
import 'package:project_tracker/utils/Prefs.dart';

class MyDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: DecoratedBox(
        child: Text("Signed in as " + Prefs().user.user["username"]),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/project_tracker_logo.png"),
          ),
        ),
      ),
      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
    );
  }
}

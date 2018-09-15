import 'package:flutter/material.dart';

import 'package:project_tracker/utils/Prefs.dart';

class DefaultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyDefaultView();
  }
}

class MyDefaultView extends StatefulWidget {
  @override
  _MyDefaultViewState createState() => _MyDefaultViewState();
}

class _MyDefaultViewState extends State<MyDefaultView> {
  String _selectedView = "User";

  @override
  void initState() {
    super.initState();
    _selectedView = Prefs().defaultView;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Select Default View"),
      children: <Widget>[
        ListTile(
          leading: Radio(
            groupValue: _selectedView,
            onChanged: (value) {
              setState(() {
                _selectedView = value;
              });
              Prefs().setDefaultView("Work Timer");
            },
            value: "Work Timer",
          ),
          onTap: () {
            setState(() {
              _selectedView = "Work Timer";
            });
            Prefs().setDefaultView("Work Timer");
          },
          title: Text("Work Timer"),
        ),
        ListTile(
          leading: Radio(
            groupValue: _selectedView,
            onChanged: (value) {
              setState(() {
                _selectedView = value;
              });
              Prefs().setDefaultView("User");
            },
            value: "User",
          ),
          onTap: () {
            setState(() {
              _selectedView = "User";
            });
            Prefs().setDefaultView("User");
          },
          title: Text("User"),
        ),
        ListTile(
          leading: Radio(
            groupValue: _selectedView,
            onChanged: (value) {
              setState(() {
                _selectedView = value;
              });
              Prefs().setDefaultView("Overview");
            },
            value: "Overview",
          ),
          onTap: () {
            setState(() {
              _selectedView = "Overview";
            });
            Prefs().setDefaultView("Overview");
          },
          title: Text("Overview"),
        ),
        ListTile(
          leading: Radio(
            groupValue: _selectedView,
            onChanged: (value) {
              setState(() {
                _selectedView = value;
              });
              Prefs().setDefaultView("Admin");
            },
            value: "Admin",
          ),
          onTap: () {
            setState(() {
              _selectedView = "Admin";
            });
            Prefs().setDefaultView("Admin");
          },
          title: Text("Admin"),
        ),
        ListTile(
          leading: Radio(
            groupValue: _selectedView,
            onChanged: (value) {
              setState(() {
                _selectedView = value;
              });
              Prefs().setDefaultView("Trash");
            },
            value: "Trash",
          ),
          onTap: () {
            setState(() {
              _selectedView = "Trash";
            });
            Prefs().setDefaultView("Trash");
          },
          title: Text("Trash"),
        ),
      ],
    );
  }
}

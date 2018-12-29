import 'package:flutter/material.dart';

import 'package:project_tracker/settings/ChangePassword.dart';
import 'package:project_tracker/settings/DefaultView.dart';
import 'package:project_tracker/utils/Prefs.dart';
import 'package:project_tracker/components/MyFlushbar.dart';

class Settings extends StatelessWidget {
  final VoidCallback _onLogout;
  final VoidCallback _update;
  final bool pop;

  Settings(this._onLogout, this._update, {this.pop: false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          leading: Text(
            "Settings",
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        ListTile(
          leading: Icon(Icons.style),
          title: Text("Dark Theme"),
          trailing: Switch(
            onChanged: (bool value) async {
              await Prefs().setTheme(value ? "dark" : "light");
              _update();
            },
            value: Prefs().theme == "dark",
          ),
        ),
        ListTile(
          leading: Icon(Icons.view_module),
          title: Text("Default View"),
          trailing: Text(
            Prefs().defaultView,
            style: Theme.of(context).textTheme.body1,
          ),
          onTap: () async {
            await showDialog(
                context: context, builder: (context) => DefaultView());
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.lock_open),
          title: Text("Change Password"),
          onTap: () async {
            bool res = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChangePassword()));
            if (res != null && res) {
              Navigator.pop(context);
              successMsg("Password Changed").show(context);
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () async {
            _onLogout();
            if (pop) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}

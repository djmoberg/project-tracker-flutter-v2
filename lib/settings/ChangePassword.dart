import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/components/MySpinner.dart';

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyChangePassword();
  }
}

class MyChangePassword extends StatefulWidget {
  @override
  _MyChangePasswordState createState() => _MyChangePasswordState();
}

class _MyChangePasswordState extends State<MyChangePassword> {
  String _newPassword = "";
  String _newPassword2 = "";
  bool _loading = false;

  bool _match() {
    return _equal() && _length();
  }

  bool _equal() {
    return _newPassword == _newPassword2;
  }

  bool _length() {
    return _newPassword.length >= 3 && _newPassword2.length >= 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: _loading
          ? Center(
              child: loaderIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "New Password"),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _newPassword = value;
                    });
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      errorText: _match()
                          ? null
                          : !_length()
                              ? "Password must be at least 3 characters"
                              : "Passwords does not match"),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _newPassword2 = value;
                    });
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  child: Text("Change Password"),
                  onPressed: _match()
                      ? () async {
                          setState(() {
                            _loading = true;
                          });
                          await newPassword({"newPassword": _newPassword});
                          setState(() {
                            _loading = false;
                          });
                          Navigator.pop(context, true);
                        }
                      : null,
                ),
              ],
            ),
    );
  }
}

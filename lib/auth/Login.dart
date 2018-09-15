import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/auth/PasswordReset.dart';
import 'package:project_tracker/auth/RegisterUser.dart';

class Login extends StatelessWidget {
  final VoidCallback _onLogin;

  Login(this._onLogin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: MyCustomForm(_onLogin));
  }
}

class MyCustomForm extends StatefulWidget {
  final VoidCallback _onLogin;

  MyCustomForm(this._onLogin);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(_onLogin);
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final VoidCallback _onLogin;

  MyCustomFormState(this._onLogin);

  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  bool _loading = false;

  void _login() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Logging in...")));
      _formKey.currentState.save();
      try {
        await login(_username, _password);
        _onLogin();
      } catch (e) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Something went wrong")));
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _formKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  Image.network(
                    "https://facelex.com/img/cooltext292638607517631.png",
                    height: 100.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    decoration: InputDecoration(labelText: "Username"),
                    onSaved: (String value) {
                      setState(() {
                        _username = value;
                      });
                    },
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onFieldSubmitted: (value) {
                      _login();
                    },
                    onSaved: (String value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: _login,
                        child: Text('Login'),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Create account"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterUser()));
                        },
                      ),
                      FlatButton(
                        child: Text("Forgot password?"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasswordReset()));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}

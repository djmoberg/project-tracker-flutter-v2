import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';

import 'package:validate/validate.dart';

class RegisterUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: MyCustomForm());
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  // String _password2 = "";
  String _email = "";
  bool _loading = false;
  bool _userExits = false;
  TextEditingController _controller = new TextEditingController();

  _exists(value) async {
    bool res = await userExists(value);
    if (this.mounted) {
      setState(() {
        _userExits = res;
      });
    }
  }

  void onChange() {
    String value = _controller.text;
    if (value != "") {
      _exists(value);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(onChange);
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
                // crossAxisAlignment: CrossAxisAlignment.start,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  TextFormField(
                    controller: _controller,
                    validator: (value) {
                      if (_userExits) {
                        return "User exist";
                      }
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    autovalidate: true,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Username"),
                    keyboardType: TextInputType.emailAddress,
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
                    onSaved: (String value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      } else if (_password != value) {
                        return 'Password does not match';
                      }
                    },
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    obscureText: true,
                    onSaved: (String value) {
                      // setState(() {
                      //   _password2 = value;
                      // });
                    },
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        try {
                          Validate.isEmail(value);
                        } catch (e) {
                          return 'The E-mail Address must be a valid email address.';
                        }
                      }
                    },
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (String value) {
                      setState(() {
                        _email = value;
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
                        onPressed: () async {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Registering...')));

                            try {
                              await registerUser({
                                "email": _email,
                                "password": _password,
                                "username": _username
                              });
                              Navigator.pop(context);
                            } catch (e) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Something went wrong')));
                            }
                            setState(() {
                              _loading = false;
                            });
                          }
                        },
                        child: Text('Register'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

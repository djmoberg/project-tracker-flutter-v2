import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/components/MyFlushbar.dart';

class RegisterProject extends StatelessWidget {
  final VoidCallback _updateProjects;

  RegisterProject(this._updateProjects);

  @override
  Widget build(BuildContext context) {
    return MyRegisterProject(_updateProjects);
  }
}

class MyRegisterProject extends StatefulWidget {
  final VoidCallback _updateProjects;

  MyRegisterProject(this._updateProjects);

  @override
  _MyRegisterProjectState createState() =>
      _MyRegisterProjectState(_updateProjects);
}

class _MyRegisterProjectState extends State<MyRegisterProject> {
  final VoidCallback _updateProjects;

  _MyRegisterProjectState(this._updateProjects);

  String _name = "";
  String _description = "";
  bool _loading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _validForm() {
    return _name != "";
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                child: Text("Register"),
                onPressed: !_validForm()
                    ? null
                    : () async {
                        setState(() {
                          _loading = true;
                        });
                        await registerProject(
                            {"description": _description, "name": _name});
                        setState(() {
                          _loading = false;
                          _name = "";
                          _description = "";
                        });
                        _nameController.clear();
                        _descriptionController.clear();
                        _updateProjects();
                        successMsg("Project Registered").show(context);
                      },
              ),
            ],
          );
  }
}

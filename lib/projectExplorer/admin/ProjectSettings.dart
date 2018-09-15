import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/utils/Prefs.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';

class ProjectSettings extends StatelessWidget {
  final Project _project;
  final VoidCallback _updateProject;

  ProjectSettings(this._project, this._updateProject);

  @override
  Widget build(BuildContext context) {
    return MyProjectSettings(_project, _updateProject);
  }
}

class MyProjectSettings extends StatefulWidget {
  final Project _project;
  final VoidCallback _updateProject;

  MyProjectSettings(this._project, this._updateProject);

  @override
  _MyProjectSettingsState createState() =>
      _MyProjectSettingsState(_project, _updateProject);
}

class _MyProjectSettingsState extends State<MyProjectSettings> {
  final Project _project;
  final VoidCallback _updateProject;

  _MyProjectSettingsState(this._project, this._updateProject);

  String _name;
  String _description;
  bool _loading = false;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  Project _liveProject;

  bool _validForm() {
    return _name != "" &&
        (_name != _liveProject.name ||
            _description != _liveProject.description);
  }

  @override
  void initState() {
    super.initState();
    _name = _project.name;
    _description = _project.description;
    _nameController = TextEditingController(text: _project.name);
    _descriptionController = TextEditingController(text: _project.description);
    _liveProject = _project;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
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
                child: Text("Save"),
                onPressed: !_validForm()
                    ? null
                    : () async {
                        setState(() {
                          _loading = true;
                        });
                        await updateProject(
                            {"newDescription": _description, "newName": _name});
                        Prefs().setProjectName(_name);
                        Prefs().setProjectDescription(_description);
                        _updateProject();
                        setState(() {
                          _loading = false;
                          _liveProject = Project(
                              id: _liveProject.id,
                              name: _name,
                              description: _description,
                              overview: _liveProject.overview);
                        });
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Project Updated")));
                      },
              ),
            ],
          );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';

class JoinProject extends StatelessWidget {
  final List<Map<String, dynamic>> _projects;

  JoinProject(this._projects);

  @override
  Widget build(BuildContext context) {
    return MyJoinProject(_projects);
  }
}

class MyJoinProject extends StatefulWidget {
  final List<Map<String, dynamic>> _projects;

  MyJoinProject(this._projects);

  @override
  _MyJoinProjectState createState() => _MyJoinProjectState(_projects);
}

class _MyJoinProjectState extends State<MyJoinProject> {
  final List<Map<String, dynamic>> _projects;

  _MyJoinProjectState(this._projects);

  List<ProjectSearch> _results = List();
  bool _loading = false;
  String _searchValue = "";
  List<dynamic> _pendingJoinRequest;
  bool _loadingPending = false;
  TextEditingController _controller = TextEditingController();

  Future _search(value) async {
    List<ProjectSearch> res = await findProjects(value);
    setState(() {
      _results = res;
    });
  }

  _getPendingJoinRequest() async {
    setState(() {
      _loadingPending = true;
    });
    List<dynamic> res = await getPendingJoinRequests();
    setState(() {
      _pendingJoinRequest = res;
      _loadingPending = false;
    });
  }

  _sendJoinRequest(int id) async {
    _controller.clear();
    setState(() {
      _searchValue = "";
    });
    await sendJoinRequest({"projectId": id});
    await _getPendingJoinRequest();
  }

  _deleteJoinRequest(int id) async {
    setState(() {
      _loadingPending = true;
    });
    await deleteJoinRequest(id.toString());
    await _getPendingJoinRequest();
  }

  bool _contains(ProjectSearch pro) {
    return !_projects.every((project) => project["id"] != pro.id) ||
        !_pendingJoinRequest.every((req) => req["id"] != pro.id);
  }

  List<ProjectSearch> _filteredResults() {
    List<ProjectSearch> filtered = List();

    _results.forEach((project) {
      if (!_contains(project)) {
        filtered.add(project);
      }
    });

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _getPendingJoinRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            onChanged: (value) async {
              setState(() {
                _searchValue = value;
              });
              if (value != "") {
                setState(() {
                  _loading = true;
                });
                await _search(value);
                setState(() {
                  _loading = false;
                });
              } else {
                setState(() {
                  _results = List();
                });
              }
            },
            decoration: InputDecoration(suffixIcon: Icon(Icons.search)),
          ),
          _loading
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16.0,
                    ),
                    CircularProgressIndicator()
                  ],
                )
              : _filteredResults().length == 0 && _searchValue != ""
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 16.0,
                        ),
                        Text("No Results")
                      ],
                    )
                  : _searchValue == ""
                      ? SizedBox()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _filteredResults().length,
                            itemBuilder: (context, index) {
                              ProjectSearch res = _filteredResults()[index];

                              return ListTile(
                                title: Text(res.name),
                                subtitle: Text(res.description),
                                trailing: RaisedButton(
                                  child: Text("Send"),
                                  onPressed: () {
                                    _sendJoinRequest(res.id);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
          SizedBox(
            height: 16.0,
          ),
          _loadingPending || _pendingJoinRequest.length == 0
              ? SizedBox()
              : Text(
                  "Pending Requests",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline,
                ),
          _loadingPending
              ? CircularProgressIndicator()
              : _pendingJoinRequest.length == 0
                  ? SizedBox()
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: _pendingJoinRequest.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_pendingJoinRequest[index]["name"]),
                            trailing: RaisedButton(
                              child: Text("Remove"),
                              color: Colors.red,
                              onPressed: () {
                                _deleteJoinRequest(
                                    _pendingJoinRequest[index]["id"]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

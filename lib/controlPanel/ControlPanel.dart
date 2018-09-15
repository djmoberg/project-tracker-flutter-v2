// import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/controlPanel/ChooseProject.dart';
import 'package:project_tracker/controlPanel/JoinProject.dart';
import 'package:project_tracker/controlPanel/RegisterProject.dart';
import 'package:project_tracker/settings/Settings.dart';

class ControlPanel extends StatelessWidget {
  final VoidCallback _onLogout;
  final VoidCallback _update;

  ControlPanel(this._onLogout, this._update);

  @override
  Widget build(BuildContext context) {
    return MyControlPanel(_onLogout, _update);
  }
}

class MyControlPanel extends StatefulWidget {
  final VoidCallback _onLogout;
  final VoidCallback _update;

  MyControlPanel(this._onLogout, this._update);

  @override
  _MyControlPanelState createState() =>
      _MyControlPanelState(_onLogout, _update);
}

class _MyControlPanelState extends State<MyControlPanel> {
  final VoidCallback _onLogout;
  final VoidCallback _update;

  _MyControlPanelState(this._onLogout, this._update);

  bool _loading = false;
  List<Map<String, dynamic>> _projects;

  _getProjects() async {
    setState(() {
      _loading = true;
    });
    List<Map<String, dynamic>> res = await getProjects();
    setState(() {
      _projects = res;
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.network(
                  "https://facelex.com/img/cooltext292638607517631.png",
                  height: 100.0,
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor),
              ),
              Settings(_onLogout, _update),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Project"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Choose",
              ),
              Tab(
                text: "New",
              ),
              Tab(
                text: "Find",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _loading
                ? Center(child: CircularProgressIndicator())
                : ChooseProject(_projects, _onLogout, _update),
            RegisterProject(() => _getProjects()),
            JoinProject(_projects),
          ],
        ),
      ),
    );
  }
}

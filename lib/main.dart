import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/auth/Login.dart';
import 'package:project_tracker/components/MySpinner.dart';
import 'package:project_tracker/controlPanel/ControlPanel.dart';
import 'package:project_tracker/utils/Prefs.dart';

Future main() async {
  await Prefs().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loggedIn();
  }

  _loggedIn() async {
    bool res = await loggedIn();
    setState(() {
      isLoggedIn = res;
    });
  }

  _onLogout() async {
    setState(() {
      loading = true;
    });
    await logout();
    await _loggedIn();
    setState(() {
      loading = false;
    });
  }

  _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Tracker',
      theme: Prefs().theme == "dark" ? ThemeData.dark() : ThemeData.light(),
      home: isLoggedIn == null || loading
          ? Scaffold(
              body: Center(child: loaderIndicator()),
            )
          : isLoggedIn
              ? ControlPanel(() => _onLogout(), () => _update())
              : Login(() => _loggedIn()),
    );
  }
}

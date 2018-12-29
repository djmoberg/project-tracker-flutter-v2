import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/components/MyFlushbar.dart';

class JoinRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyJoinRequests();
  }
}

class MyJoinRequests extends StatefulWidget {
  @override
  _MyJoinRequestsState createState() => _MyJoinRequestsState();
}

class _MyJoinRequestsState extends State<MyJoinRequests> {
  List<dynamic> _requests;
  bool _loading = false;

  _getJoinRequests() async {
    setState(() {
      _loading = true;
    });
    List<dynamic> res = await getJoinRequests();
    setState(() {
      _requests = res;
      _loading = false;
    });
  }

  _deleteProjectJoinRequest(userId, username) async {
    setState(() {
      _loading = true;
    });
    await deleteProjectJoinRequest(userId);
    await _getJoinRequests();
    infoMsg(username + " was rejected from the project").show(context);
  }

  List<Widget> _joinWidgets() {
    List<Widget> widgets = List();

    _requests.forEach((request) {
      widgets.add(
        ListTile(
          title: Row(
            children: <Widget>[
              Expanded(child: Text(request["name"])),
              IconButton(
                icon: Icon(Icons.clear),
                color: Colors.red,
                onPressed: () =>
                    _deleteProjectJoinRequest(request["id"], request["name"]),
              ),
              IconButton(
                icon: Icon(Icons.check),
                color: Colors.green,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    });

    return widgets;
  }

  @override
  void initState() {
    super.initState();
    _getJoinRequests();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : _requests.length == 0
            ? Text("No requests")
            : Column(
                children: _joinWidgets(),
              );
  }
}

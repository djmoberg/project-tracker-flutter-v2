import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/components/MySpinner.dart';
import 'package:project_tracker/utils/Prefs.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';
import 'package:project_tracker/utils/utils.dart';

class AddDialog extends StatelessWidget {
  final int _startTime;
  final int _stopTime;
  final VoidCallback _updateOverview;

  AddDialog(this._startTime, this._stopTime, this._updateOverview);

  @override
  Widget build(BuildContext context) {
    return MyAddDialog(_startTime, _stopTime, _updateOverview);
  }
}

class MyAddDialog extends StatefulWidget {
  final int _startTime;
  final int _stopTime;
  final VoidCallback _updateOverview;

  MyAddDialog(this._startTime, this._stopTime, this._updateOverview);

  @override
  _MyAddDialogState createState() =>
      _MyAddDialogState(_startTime, _stopTime, _updateOverview);
}

class _MyAddDialogState extends State<MyAddDialog> {
  final int _startTime;
  final int _stopTime;
  final VoidCallback _updateOverview;

  _MyAddDialogState(this._startTime, this._stopTime, this._updateOverview);

  String _comment = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clock Out"),
      ),
      body: _loading
          ? Center(child: loaderIndicator())
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                ListTile(
                  leading: Text("Date"),
                  title: Text(convertDate(
                      DateTime.fromMillisecondsSinceEpoch(_startTime))),
                ),
                ListTile(
                  leading: Text("From"),
                  title: Text(formatTimeRounded(_startTime)),
                ),
                ListTile(
                  leading: Text("To"),
                  title: Text(formatTimeRounded(_stopTime)),
                ),
                ListTile(
                  leading: Text("Hours"),
                  title: Text(getHours(formatTimeRounded(_startTime),
                      formatTimeRounded(_stopTime))),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _comment = value;
                    });
                  },
                  // autofocus: true,
                  maxLines: 5,
                  decoration: InputDecoration(labelText: "Comment"),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    RaisedButton(
                      child: Text("Save"),
                      onPressed: _comment.length == 0
                          ? null
                          : () async {
                              setState(() {
                                _loading = true;
                              });
                              RAdd res = await addWork({
                                "addedUsers": [],
                                "comment": _comment,
                                "workDate": convertDateBackend(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        _startTime)),
                                "workFrom": formatTimeRounded(_startTime),
                                "workTo": formatTimeRounded(_stopTime)
                              });
                              Prefs().setOverview(res.overview);
                              _updateOverview();
                              await deleteWorkTimer();
                              Navigator.pop(context, true);
                            },
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

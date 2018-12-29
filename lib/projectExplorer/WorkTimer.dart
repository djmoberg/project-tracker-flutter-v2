import 'dart:async';

import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/projectExplorer/workTimer/AddDialog.dart';
import 'package:project_tracker/utils/utils.dart';
import 'package:project_tracker/components/MyFlushbar.dart';

class WorkTimer extends StatelessWidget {
  final VoidCallback _updateOverview;

  WorkTimer(this._updateOverview);

  @override
  Widget build(BuildContext context) {
    return MyWorkTimer(_updateOverview);
  }
}

class MyWorkTimer extends StatefulWidget {
  final VoidCallback _updateOverview;

  MyWorkTimer(this._updateOverview);

  @override
  _MyWorkTimerState createState() => _MyWorkTimerState(_updateOverview);
}

class _MyWorkTimerState extends State<MyWorkTimer> {
  final VoidCallback _updateOverview;

  _MyWorkTimerState(this._updateOverview);

  int _startTime;
  String _currentTime = "00:00:00";
  Timer _timer;
  int _savedTime;

  _getWorkTimer() async {
    int res = await getWorkTimer();
    setState(() {
      _startTime = res;
    });
    if (res != 0) {
      _startTimer();
    }
  }

  void _updateTime(timer) {
    setState(() {
      _currentTime =
          formatTime(DateTime.now().millisecondsSinceEpoch - _startTime);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500), _updateTime);
  }

  bool validClockOut() {
    int stopTime = DateTime.now().millisecondsSinceEpoch;
    String hours =
        getHours(formatTimeRounded(_startTime), formatTimeRounded(stopTime));
    if (hours == "0") {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _getWorkTimer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _startTime == null
          ? CircularProgressIndicator()
          : _startTime == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        "Clock In",
                        style: Theme.of(context).textTheme.display2,
                      ),
                      onPressed: () {
                        int now = DateTime.now().millisecondsSinceEpoch;
                        setState(() {
                          _startTime = now;
                        });
                        _startTimer();
                        setWorkTimer(now);
                      },
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    _savedTime == null
                        ? SizedBox()
                        : RaisedButton(
                            child: Text(
                              "Restore",
                              style: Theme.of(context).textTheme.display2,
                            ),
                            onPressed: () async {
                              setState(() {
                                _startTime = _savedTime;
                              });
                              _startTimer();
                              await setWorkTimer(_savedTime);
                              setState(() {
                                _savedTime = null;
                              });
                            },
                          ),
                  ],
                )
              : ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text("You Started Working"),
                      subtitle: Text(convertDateFull(
                          DateTime.fromMillisecondsSinceEpoch(_startTime))),
                    ),
                    ListTile(
                      leading: Icon(Icons.timer),
                      title: Text("Work Time"),
                      subtitle: Text(_currentTime),
                    ),
                    ListTile(
                      title: RaisedButton(
                        child: Text("Clock Out"),
                        onPressed: () async {
                          int stopTime = DateTime.now().millisecondsSinceEpoch;
                          String hours = getHours(formatTimeRounded(_startTime),
                              formatTimeRounded(stopTime));
                          if (hours == "0.0") {
                            infoMsg("You must work for at least 15 minutes!")
                                .show(context);
                          } else {
                            bool workAdded = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddDialog(
                                  _startTime, stopTime, _updateOverview);
                            }));
                            if (workAdded != null && workAdded) {
                              successMsg("Work added").show(context);
                              _timer.cancel();
                              setState(() {
                                _startTime = null;
                                _currentTime = "00:00:00";
                              });
                              _getWorkTimer();
                            }
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: RaisedButton(
                        color: Theme.of(context).errorColor,
                        child: Text("Cancel"),
                        onPressed: () async {
                          _timer.cancel();
                          setState(() {
                            _savedTime = _startTime;
                            _startTime = null;
                            _currentTime = "00:00:00";
                          });
                          await deleteWorkTimer();
                          setState(() {
                            _startTime = 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

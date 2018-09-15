import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/utils/Prefs.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';
import 'package:project_tracker/utils/utils.dart';

class Trash extends StatelessWidget {
  final VoidCallback _updateOverview;

  Trash(this._updateOverview);

  @override
  Widget build(BuildContext context) {
    return MyTrash(_updateOverview);
  }
}

class MyTrash extends StatefulWidget {
  final VoidCallback _updateOverview;

  MyTrash(this._updateOverview);

  @override
  _MyTrashState createState() => _MyTrashState(_updateOverview);
}

class _MyTrashState extends State<MyTrash> {
  final VoidCallback _updateOverview;

  _MyTrashState(this._updateOverview);

  List<DeletedWork> _list;
  List<bool> _checkboxes;
  bool _loading = false;
  bool _restoring = false;

  _getDeletedWork() async {
    setState(() {
      _loading = true;
    });
    List<DeletedWork> res = await getDeletedWork();
    setState(() {
      _list = res;
      _checkboxes = List.generate(res.length, (index) => false);
      _loading = false;
    });
  }

  bool _nonSelected() {
    return _checkboxes.every((selected) => !selected);
  }

  @override
  void initState() {
    super.initState();
    _getDeletedWork();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _list.length == 0
            ? Center(
                child: Text("Empty"),
              )
            : _restoring
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("Restoring"),
                      ],
                    ),
                  )
                : Column(
                    children: <Widget>[
                      _nonSelected()
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text("Restore"),
                                    onPressed: () async {
                                      setState(() {
                                        _restoring = true;
                                      });
                                      RAdd finalRes;
                                      for (int i = 0; i < _list.length; i++) {
                                        if (_checkboxes[i]) {
                                          var work = _list[i];
                                          finalRes = await addWork({
                                            "addedUsers": [],
                                            "comment": work.comment,
                                            "workDate": work.workDate,
                                            "workFrom": work.workFrom,
                                            "workTo": work.workTo
                                          });
                                          await deleteTrash(work.id);
                                          // setState(() {
                                          //   _checkboxes.removeAt(i);
                                          //   _list.removeAt(i);
                                          // });
                                        }
                                      }
                                      setState(() {
                                        _restoring = false;
                                      });
                                      _getDeletedWork();
                                      Prefs().setOverview(finalRes.overview);
                                      _updateOverview();
                                    },
                                  ),
                                  RaisedButton(
                                    child: Text("Delete"),
                                    color: Colors.red,
                                    onPressed: () async {
                                      setState(() {
                                        _loading = true;
                                      });

                                      for (int i = 0; i < _list.length; i++) {
                                        if (_checkboxes[i]) {
                                          var work = _list[i];

                                          await deleteTrash(work.id);
                                        }
                                      }

                                      _getDeletedWork();
                                    },
                                  ),
                                ],
                              ),
                            ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(16.0),
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            var data = _list[index];
                            String workDate = data.workDate;
                            String time = "${data.workFrom} - ${data.workTo}";
                            String hours = getHours(data.workFrom, data.workTo);
                            String comment = data.comment;
                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(workDate),
                                        Text(time),
                                        Text(hours),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Text(comment),
                                leading: Checkbox(
                                  onChanged: (bool value) {
                                    setState(() {
                                      _checkboxes[index] = value;
                                    });
                                  },
                                  value: _checkboxes[index],
                                ),
                                onTap: () {
                                  setState(() {
                                    _checkboxes[index] = !_checkboxes[index];
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
  }
}

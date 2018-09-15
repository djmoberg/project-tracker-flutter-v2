import 'package:flutter/material.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/components/CustomCard.dart';
import 'package:project_tracker/projectExplorer/user/Edit.dart';
import 'package:project_tracker/utils/Prefs.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';
import 'package:project_tracker/utils/utils.dart';

class UserOverview extends StatelessWidget {
  final Project _project;
  final VoidCallback _updateOverview;

  UserOverview(this._project, this._updateOverview);

  @override
  Widget build(BuildContext context) {
    return MyUserOverview(_project, _updateOverview);
  }
}

class MyUserOverview extends StatefulWidget {
  final Project _project;
  final VoidCallback _updateOverview;

  MyUserOverview(this._project, this._updateOverview);

  @override
  _MyUserOverviewState createState() =>
      _MyUserOverviewState(_project, _updateOverview);
}

class _MyUserOverviewState extends State<MyUserOverview> {
  final Project _project;
  final VoidCallback _updateOverview;

  _MyUserOverviewState(this._project, this._updateOverview);

  List<dynamic> _overview;
  String _selectedUser;
  String _selectedMonth = "All";
  String _selectedYear = "All";

  List<DropdownMenuItem> _monthList() {
    List<DropdownMenuItem> res = List();

    res.add(DropdownMenuItem(
      child: Text("All"),
      value: "All",
    ));
    res.add(DropdownMenuItem(
      child: Text("January"),
      value: "01",
    ));
    res.add(DropdownMenuItem(
      child: Text("February"),
      value: "02",
    ));
    res.add(DropdownMenuItem(
      child: Text("March"),
      value: "03",
    ));
    res.add(DropdownMenuItem(
      child: Text("April"),
      value: "04",
    ));
    res.add(DropdownMenuItem(
      child: Text("May"),
      value: "05",
    ));
    res.add(DropdownMenuItem(
      child: Text("June"),
      value: "06",
    ));
    res.add(DropdownMenuItem(
      child: Text("July"),
      value: "07",
    ));
    res.add(DropdownMenuItem(
      child: Text("August"),
      value: "08",
    ));
    res.add(DropdownMenuItem(
      child: Text("September"),
      value: "09",
    ));
    res.add(DropdownMenuItem(
      child: Text("October"),
      value: "10",
    ));
    res.add(DropdownMenuItem(
      child: Text("November"),
      value: "11",
    ));
    res.add(DropdownMenuItem(
      child: Text("December"),
      value: "12",
    ));

    return res;
  }

  List<DropdownMenuItem> _yearList() {
    List<Map<String, String>> list = uniqueYearList(_overview);
    List<DropdownMenuItem> res = List();

    res.add(DropdownMenuItem(
      child: Text("All"),
      value: "All",
    ));

    list.forEach((field) {
      res.add(DropdownMenuItem(
        child: Text(field["text"]),
        value: field["value"],
      ));
    });

    return res;
  }

  bool _isCurrentlySelected(overview) {
    return ((_selectedUser == overview["name"] || _selectedUser == "All") &&
        (_selectedMonth == overview["workDate"].split("-")[1] ||
            _selectedMonth == "All") &&
        (_selectedYear == overview["workDate"].split("-")[0] ||
            _selectedYear == "All"));
  }

  List<dynamic> _sortList(List<dynamic> overview) {
    // overview.sort((a, b) {
    //   if (a["workDate"] == b["workDate"]) {
    //     return b["workFrom"].compareTo(a["workFrom"]);
    //   } else {
    //     return 0;
    //   }
    // });
    return overview;
  }

  List<dynamic> _filteredList(List<dynamic> overview) {
    return _sortList(
        overview.where((row) => _isCurrentlySelected(row)).toList());
  }

  @override
  void initState() {
    super.initState();
    _overview = _project.overview;
    _selectedUser = Prefs().user.user["username"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Your work on this project",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Hours total: " + getTotalHours(_filteredList(_overview))),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            DropdownButton(
              value: _selectedMonth,
              items: _monthList(),
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value;
                });
              },
            ),
            DropdownButton(
              value: _selectedYear,
              items: _yearList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 70.0),
            itemCount: _filteredList(_overview).length,
            itemBuilder: (context, index) {
              var data = _filteredList(_overview)[index];
              // String name = data["name"];
              int id = data["id"];
              String workDate = data["workDate"];
              String time = "${data["workFrom"]} - ${data["workTo"]}";
              String hours = getHours(data["workFrom"], data["workTo"]);
              String comment = data["comment"];
              return Dismissible(
                child: GestureDetector(
                  onTap: () async {
                    bool edited = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Edit(
                                  _updateOverview,
                                  work: {
                                    "comment": comment,
                                    "workDate": workDate,
                                    "workFrom": data["workFrom"],
                                    "workTo": data["workTo"],
                                    "id": id
                                  },
                                )));
                    if (edited != null && edited) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("Work edited")));
                    }
                  },
                  child: CustomCard(workDate, time, hours, comment),
                ),
                key: Key(id.toString()),
                background: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.delete),
                        Icon(Icons.delete)
                      ],
                    ),
                  ),
                ),
                onDismissed: (direction) async {
                  bool moved = await moveToTrash(data);
                  if (moved) {
                    RAdd res = await deleteWork(id);
                    Prefs().setOverview(res.overview);
                    _updateOverview();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Work moved to trash"),
                      duration: Duration(seconds: 1),
                    ));
                  } else {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Something went wrong")));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

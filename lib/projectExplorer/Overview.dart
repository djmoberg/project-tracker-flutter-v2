import 'package:flutter/material.dart';

import 'package:project_tracker/utils/ResponseObjects.dart';
import 'package:project_tracker/utils/utils.dart';

class Overview extends StatelessWidget {
  final Project _project;

  Overview(this._project);

  @override
  Widget build(BuildContext context) {
    return MyOverview(_project);
  }
}

class MyOverview extends StatefulWidget {
  final Project _project;

  MyOverview(this._project);

  @override
  _MyOverviewState createState() => _MyOverviewState(_project);
}

class _MyOverviewState extends State<MyOverview> {
  final Project _project;

  _MyOverviewState(this._project);

  List<dynamic> _overview;
  String _selectedUser = "All";
  String _selectedMonth = "All";
  String _selectedYear = "All";

  List<DropdownMenuItem> _userList() {
    List<Map<String, String>> list = uniqueUserList(_overview);
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

  List<DropdownMenuItem> _monthList() {
    List<Map<String, String>> list = monthList();
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DropdownButton(
              value: _selectedUser,
              items: _userList(),
              onChanged: (value) {
                setState(() {
                  _selectedUser = value;
                });
              },
            ),
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
            itemCount: _filteredList(_overview).length,
            itemBuilder: (context, index) {
              var data = _filteredList(_overview)[index];
              String name = data["name"];
              String workDate = data["workDate"];
              String time = "${data["workFrom"]} - ${data["workTo"]}";
              String hours = getHours(data["workFrom"], data["workTo"]);
              String comment = data["comment"];
              return Card(
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(workDate),
                          Text(time),
                          Text(hours),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Text(comment),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/utils/Prefs.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';
import 'package:project_tracker/utils/utils.dart';

class Edit extends StatelessWidget {
  Edit(this._updateOverview, {Key key, this.work}) : super(key: key);

  final VoidCallback _updateOverview;
  final Map<String, dynamic> work;

  @override
  Widget build(BuildContext context) {
    return MyEdit(this._updateOverview, work: work);
  }
}

class MyEdit extends StatefulWidget {
  MyEdit(this._updateOverview, {Key key, this.work}) : super(key: key);

  final VoidCallback _updateOverview;
  final Map<String, dynamic> work;

  @override
  _MyEditState createState() => _MyEditState(this._updateOverview);
}

class _MyEditState extends State<MyEdit> {
  final VoidCallback _updateOverview;

  _MyEditState(this._updateOverview);

  bool addMode;
  DateTime _date;
  String fromH;
  String fromM;
  String toH;
  String toM;
  String _comment;
  bool _loading = false;
  TextEditingController _controller;

  @override
  void initState() {
    print(widget.work);
    super.initState();
    addMode = widget.work == null;
    if (addMode) {
      _controller = TextEditingController();
      _date = DateTime.now();
      fromH = withZero(DateTime.now().hour);
      fromM = "00";
      toH = withZero(DateTime.now().hour);
      toM = "15";
      _comment = "";
    } else {
      var work = widget.work;
      _controller = TextEditingController(text: work["comment"]);
      var workDate = work["workDate"].split("-");
      _date = DateTime(
        int.parse(workDate[0]),
        int.parse(workDate[1]),
        int.parse(workDate[2]),
      );
      fromH = work["workFrom"].split(":")[0];
      fromM = work["workFrom"].split(":")[1];
      toH = work["workTo"].split(":")[0];
      toM = work["workTo"].split(":")[1];
      _comment = work["comment"];
    }
  }

  bool _validForm() {
    return _comment != "" && _validTime();
  }

  bool _validTime() {
    String workFrom = "$fromH:$fromM";
    String workTo = "$toH:$toM";
    String hours = getHours(workFrom, workTo);
    bool validTime = double.parse(hours) > 0.0;
    return validTime;
  }

  _openDatePicker() async {
    DateTime date = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year),
        initialDate: _date,
        lastDate: DateTime.now());

    if (date != null) {
      setState(() {
        _date = date;
      });
    }
  }

  List<DropdownMenuItem> _hList() {
    List<DropdownMenuItem> res = List.generate(24, (i) {
      return DropdownMenuItem(
        child: Text(withZero(i)),
        value: withZero(i),
      );
    });

    return res;
  }

  List<DropdownMenuItem> _mList() {
    List<DropdownMenuItem> res = List();

    res.add(DropdownMenuItem(child: Text("00"), value: "00"));
    res.add(DropdownMenuItem(child: Text("15"), value: "15"));
    res.add(DropdownMenuItem(child: Text("30"), value: "30"));
    res.add(DropdownMenuItem(child: Text("45"), value: "45"));

    return res;
  }

  _timepicker(String title, type) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.headline),
          Row(
            children: <Widget>[
              DropdownButton(
                items: _hList(),
                value: type == "from" ? fromH : toH,
                onChanged: (value) {
                  setState(() {
                    if (type == "from")
                      fromH = value;
                    else
                      toH = value;
                  });
                },
              ),
              SizedBox(width: 16.0),
              Text(":"),
              SizedBox(width: 16.0),
              DropdownButton(
                items: _mList(),
                value: type == "from" ? fromM : toM,
                onChanged: (value) {
                  setState(() {
                    if (type == "from")
                      fromM = value;
                    else
                      toM = value;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _addWork() async {
    setState(() {
      _loading = true;
    });
    var workObject = {
      "addedUsers": [],
      "comment": _comment,
      "workDate": convertDateBackend(_date),
      "workFrom": "$fromH:$fromM",
      "workTo": "$toH:$toM"
    };
    RAdd res;

    if (addMode)
      res = await addWork(workObject);
    else {
      workObject["id"] = widget.work["id"];
      res = await editWork(workObject);
    }

    Prefs().setOverview(res.overview);
    _updateOverview();
    setState(() {
      _date = DateTime.now();
      fromH = withZero(DateTime.now().hour);
      fromM = "00";
      toH = withZero(DateTime.now().hour);
      toM = "15";
      _comment = "";
      _loading = false;
    });
    _controller.clear();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(addMode ? "Add work" : "Edit work"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          _loading ? Center(child: CircularProgressIndicator()) : SizedBox(),
          ListTile(
            title: Text(
              "Date:",
              style: Theme.of(context).textTheme.headline,
            ),
            trailing: RawMaterialButton(
              child: Text(
                convertDate(_date),
                style: Theme.of(context).textTheme.headline,
              ),
              onPressed: _openDatePicker,
            ),
          ),
          SizedBox(height: 16.0),
          _timepicker("From:", "from"),
          _validTime()
              ? SizedBox()
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Time from must be after time to",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
          SizedBox(height: 16.0),
          _timepicker("To:", "to"),
          SizedBox(height: 32.0),
          Center(
            child: Text("Comment", style: Theme.of(context).textTheme.headline),
          ),
          TextField(
            maxLines: 5,
            controller: _controller,
            onChanged: (value) {
              setState(() {
                _comment = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          RaisedButton(
            child: Text(addMode ? "Add" : "Edit"),
            onPressed: !_validForm() || _loading ? null : _addWork,
          ),
        ],
      ),
    );
  }
}

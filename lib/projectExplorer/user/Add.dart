import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:project_tracker/api/api.dart';
import 'package:project_tracker/utils/Prefs.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';
import 'package:project_tracker/utils/utils.dart';

class Add extends StatelessWidget {
  final VoidCallback _updateOverview;

  Add(this._updateOverview);

  @override
  Widget build(BuildContext context) {
    return MyAdd(this._updateOverview);
  }
}

class MyAdd extends StatefulWidget {
  final VoidCallback _updateOverview;

  MyAdd(this._updateOverview);

  @override
  _MyAddState createState() => _MyAddState(this._updateOverview);
}

class _MyAddState extends State<MyAdd> {
  final VoidCallback _updateOverview;

  _MyAddState(this._updateOverview);

  DateTime _date = DateTime.now();
  String fromH = withZero(DateTime.now().hour);
  String fromM = "00";
  String toH = withZero(DateTime.now().hour);
  String toM = "15";
  String _comment = "";
  bool _loading = false;
  TextEditingController _controller;

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
    RAdd res = await addWork(workObject);
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
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Work"),
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
            child: Text("Add"),
            onPressed: !_validForm() || _loading ? null : _addWork,
          ),
        ],
      ),
    );
  }
}

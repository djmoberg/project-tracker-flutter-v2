import 'package:flutter/material.dart';

import 'package:project_tracker/utils/utils.dart';

class OverviewCard extends StatelessWidget {
  final Map<String, dynamic> _data;

  OverviewCard(this._data);

  @override
  Widget build(BuildContext context) {
    String name = _data["name"];
    String workDate = _data["workDate"];
    String time = "${_data["workFrom"]} - ${_data["workTo"]}";
    String hours = getHours(_data["workFrom"], _data["workTo"]);
    String comment = _data["comment"];
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
  }
}

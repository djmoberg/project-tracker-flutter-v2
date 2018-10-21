import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String _workDate;
  final String _time;
  final String _hours;
  final String _comment;

  CustomCard(this._workDate, this._time, this._hours, this._comment);

  @override
  Widget build(BuildContext context) {
    return MyCustomCard(_workDate, _time, _hours, _comment);
  }
}

class MyCustomCard extends StatefulWidget {
  final String _workDate;
  final String _time;
  final String _hours;
  final String _comment;

  MyCustomCard(this._workDate, this._time, this._hours, this._comment);

  @override
  _MyCustomCardState createState() =>
      _MyCustomCardState(_workDate, _time, _hours, _comment);
}

class _MyCustomCardState extends State<MyCustomCard> {
  final String _workDate;
  final String _time;
  final String _hours;
  final String _comment;

  _MyCustomCardState(this._workDate, this._time, this._hours, this._comment);

  bool _expanded = false;

  onExpandPress(overflown) => overflown
      ? () {
          setState(() {
            _expanded = !_expanded;
          });
        }
      : null;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: LayoutBuilder(builder: (context, size) {
        // Build the textspan
        var span = TextSpan(
          text: _comment,
        );

        // Use a textpainter to determine if it will exceed max lines
        var tp = TextPainter(
          maxLines: 1,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          text: span,
        );

        // trigger it to layout
        tp.layout(maxWidth: size.maxWidth - 48);

        // whether the text overflowed or not
        var overflown = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
                leading: Text(_workDate),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_time),
                    Text(_hours + " h"),
                  ],
                ),
                trailing: overflown
                    ? IconButton(
                        icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: onExpandPress(overflown),
                      )
                    : IconButton(
                        icon: Icon(null),
                        onPressed: null,
                      )),
            Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0, right: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text.rich(
                    span,
                    maxLines: _expanded ? null : 1,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Card(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         // Text(name),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(workDate),
//                             Text(time),
//                             Text(hours),
//                           ],
//                         ),
//                       ],
//                     ),
//                     subtitle: Text(comment),
//                     onTap: () {
//                       Scaffold.of(context).showSnackBar(SnackBar(
//                         content: Text("TODO: edit"),
//                         duration: Duration(seconds: 1),
//                       ));
//                     },
//                   ),
//                 ),

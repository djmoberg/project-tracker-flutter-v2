import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar infoMsg(msg, [duration = 8]) {
  Flushbar flush;
  flush = Flushbar(
    message: msg,
    backgroundColor: Colors.grey,
    icon: Icon(Icons.info),
    duration: Duration(seconds: duration),
    mainButton: FlatButton(
      child: Text("CLOSE"),
      onPressed: () => flush.dismiss(),
    ),
  );
  return flush;
}

Flushbar successMsg(msg, [duration = 8]) {
  Flushbar flush;
  flush = Flushbar(
    message: msg,
    backgroundColor: Colors.green,
    icon: Icon(Icons.check),
    duration: Duration(seconds: duration),
    mainButton: FlatButton(
      child: Text("CLOSE"),
      onPressed: () => flush.dismiss(),
    ),
  );
  return flush;
}

Flushbar errorMsg([msg = "Something went wrong", duration = 8]) {
  Flushbar flush;
  flush = Flushbar(
    message: msg,
    backgroundColor: Colors.red,
    icon: Icon(Icons.error),
    duration: Duration(seconds: duration),
    mainButton: FlatButton(
      child: Text("CLOSE"),
      onPressed: () => flush.dismiss(),
    ),
  );
  return flush;
}

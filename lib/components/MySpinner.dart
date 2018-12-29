import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loaderIndicator() {
  return SpinKitFadingCircle(
    itemBuilder: (_, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );
}

Widget imageLoaderIndicator(context) {
  return SpinKitPulse(
    color: Theme.of(context).textTheme.body1.color,
    size: 32.0,
  );
}

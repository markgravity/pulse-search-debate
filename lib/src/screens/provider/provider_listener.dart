import 'package:flutter/material.dart';

class ProviderListener extends StatelessWidget {
  final Widget child;
  final Widget listenWidget;

  const ProviderListener({Key key, this.listenWidget, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      child,
      listenWidget,
    ]);
  }
}

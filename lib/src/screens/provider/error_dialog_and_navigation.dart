import 'package:flutter/material.dart';
import 'package:pulse_search/src/providers/helpers.dart';

import '../call_screen.dart';

class ErrorDialogAndNavigation extends StatefulWidget {
  final Error error;
  final Function backFunction;
  final SearchState searchState;

  const ErrorDialogAndNavigation({
    Key key,
    @required this.error,
    @required this.backFunction,
    @required this.searchState,
  }) : super(key: key);

  @override
  _ErrorDialogAndNavigationState createState() =>
      _ErrorDialogAndNavigationState();
}

class _ErrorDialogAndNavigationState extends State<ErrorDialogAndNavigation> {
  @override
  void didUpdateWidget(ErrorDialogAndNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchState == SearchState.CONNECTED) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => CallScreen()));
      });
    }

    if (oldWidget.error == null && widget.error != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          showDialog(
            barrierDismissible: false,
            context: context,
            child: AlertDialog(
              key: Key('error_dialog_and_navigator'),
              content: Text(widget.error.toString()),
              actions: <Widget>[
                FlatButton(
                  key: Key("search_screen_close_button"),
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.backFunction();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: Key('error_dialog_placeholder_and_navigation'));
  }
}

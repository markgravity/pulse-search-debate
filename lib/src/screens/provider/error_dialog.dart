import 'package:flutter/material.dart';
import 'package:pulse_search/src/providers/helpers.dart';

import '../call_screen.dart';

class ErrorDialog extends StatefulWidget {
  final Error error;
  final Function backFunction;
  final SearchState searchState;

  const ErrorDialog({Key key, this.error, this.backFunction, this.searchState})
      : super(key: key);

  @override
  _ErrorDialogState createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  void didUpdateWidget(ErrorDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchState == SearchState.CONNECTED) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => CallScreen()));
      });
    }

    if (oldWidget.error == null && widget.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          barrierDismissible: false,
            context: context,
            child: AlertDialog(
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
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

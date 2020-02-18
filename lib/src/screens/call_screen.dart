import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pulse_search/locator.dart';
import 'package:pulse_search/src/blocs/bloc.dart';
import 'package:pulse_search/src/core/environment.dart';
import 'package:pulse_search/src/screens/bloc/search_screen.dart' as bloc;
import 'package:pulse_search/src/screens/provider//search_screen.dart' as prov;

class CallScreen extends StatelessWidget {
  //

  @override
  Widget build(BuildContext context) {
    final env = Provider.of<Environment>(context);
    return Scaffold(
      key: Key('call_screen'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              key: Key("call_screen_next_button"),
              child: Text("Next"),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  switch (env) {
                    case Environment.bloc:
                      return BlocProvider(
                        create: (_) => locator.get<SearchBloc>(),
                        child: bloc.Screen(),
                      );
                    case Environment.provider:
                      return prov.Screen();
                  }

                  return SizedBox.shrink();
                }));
              },
            ),
            RaisedButton(
              key: Key("call_screen_end_button"),
              child: Text("End"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

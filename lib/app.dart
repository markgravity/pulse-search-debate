import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_search/src/core/environment.dart';
import 'package:pulse_search/src/providers/search_provider.dart';
import 'package:pulse_search/src/screens/home_screen.dart';

import 'locator.dart';

class App extends StatelessWidget {
  App({@required this.env});

  final Environment env;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: env,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => locator<SearchProvider>()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo (Bloc)',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}

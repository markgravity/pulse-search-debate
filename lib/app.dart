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
            primarySwatch: Colors.blue,
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}

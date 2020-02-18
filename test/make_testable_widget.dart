import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_search/locator.dart';
import 'package:pulse_search/src/core/environment.dart';
import 'package:pulse_search/src/providers/search_provider.dart';

Widget makeTestableWidget(Widget child) {
  return Provider.value(
    value: Environment.provider,
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<SearchProvider>()),
      ],
      child: MaterialApp(
        home: child,
      ),
    ),
  );
}

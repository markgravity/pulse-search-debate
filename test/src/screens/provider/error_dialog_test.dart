import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_search/locator.dart';
import 'package:pulse_search/src/core/response_error.dart';
import 'package:pulse_search/src/providers/helpers.dart';
import 'package:pulse_search/src/screens/provider/error_dialog_and_navigation.dart';

import '../../../make_testable_widget.dart';

void main() {
  testWidgets('#1 test error dialog and back button', (tester) async {
    var testValue = true;
    var testFunction = () => testValue = !testValue;

    final dialogAndNavigation = makeTestableWidget(ErrorDialogAndNavigation(
      backFunction: testFunction,
      error: null,
      searchState: SearchState.BEGIN,
    ));

    await tester.pumpWidget(dialogAndNavigation);

    expect(find.byKey(Key('error_dialog_and_navigator')), findsNothing);
    expect(find.byKey(Key('search_screen_close_button')), findsNothing);

    final dialogAndNavigation1 = makeTestableWidget(ErrorDialogAndNavigation(
      backFunction: testFunction,
      error: ResponseError(''),
      searchState: SearchState.BEGIN,
    ));

    await tester.pumpWidget(dialogAndNavigation1);
    await tester.pump();

    final closeBtn = find.byKey(Key('search_screen_close_button'));

    expect(find.byKey(Key('error_dialog_and_navigator')), findsOneWidget);
    expect(closeBtn, findsOneWidget);

    await tester.tap(closeBtn);
    await tester.pump();

    expect(find.byKey(Key('error_dialog_and_navigator')), findsNothing);
    expect(find.byKey(Key('search_screen_close_button')), findsNothing);
    expect(testValue, false);
  });

  testWidgets('#2 test navigation. Move to connected screen', (tester) async {
    configureLocator();

    final dialogAndNavigation = makeTestableWidget(ErrorDialogAndNavigation(
      backFunction: () {},
      error: null,
      searchState: SearchState.BEGIN,
    ));

    await tester.pumpWidget(dialogAndNavigation);

    expect(find.byKey(Key('error_dialog_placeholder_and_navigation')),
        findsOneWidget);
    expect(find.byKey(Key('call_screen')), findsNothing);

    final dialogAndNavigation1 = makeTestableWidget(ErrorDialogAndNavigation(
      backFunction: () {},
      error: null,
      searchState: SearchState.CONNECTED,
    ));

    await tester.pumpWidget(dialogAndNavigation1);
    await tester.pumpAndSettle();

    expect(find.byKey(Key('error_dialog_placeholder_and_navigation')),
        findsNothing);
    expect(find.byKey(Key('call_screen')), findsOneWidget);
  });
}


import 'package:flutter_driver/flutter_driver.dart';
import 'package:pulse_search/src/data/waiting_status.dart';
import 'package:test/test.dart';

void main() {
	group("Pulse Search using bloc", () {
		FlutterDriver driver;

		// UI
		final beginButton = find.byValueKey("home_screen_begin_button");
		final backButton = find.byValueKey("search_screen_back_button");
		final skipButton = find.byValueKey("search_screen_skipbutton");
		final startButton = find.byValueKey("search_screen_start_button");
		final closeButton = find.byValueKey("search_screen_close_button");
		final nextButton = find.byValueKey("call_screen_next_button");
		final endButton = find.byValueKey("call_screen_end_button");
		final statusText = find.byValueKey("search_screen_status_text");
		
		// Connect to the Flutter driver before running any tests.
		setUpAll(() async {
			driver = await FlutterDriver.connect();
		});

		// Close the connection to the driver after the tests have completed.
		tearDownAll(() async {
			if (driver != null) {
				driver.close();
			}
		});

//		test("#1 Back before searching begin", () async {
//			await driver.waitFor(beginButton);
//			await driver.tap(beginButton);
//
//			await driver.runUnsynchronized(() async {
//				await driver.waitFor(backButton);
//				expect(await driver.getText(statusText), startsWith("Begin in"));
//				await driver.tap(backButton);
//				await driver.waitFor(beginButton);
//			});
//		});
//
//		test("#2 Back when searching", () async {
//			await driver.waitFor(beginButton);
//			await driver.tap(beginButton);
//
//			await driver.runUnsynchronized(() async {
//				await driver.waitFor(find.text(waitingStatus[0]));
//				await driver.tap(backButton);
//				await driver.waitFor(beginButton);
//			});
//		});


		test("#1 Home -> Search -> Call -> Search..", () async {
			try {
				await driver.waitFor(beginButton);
				await driver.tap(beginButton);

				await driver.runUnsynchronized(() async {
					while (true) {

						print("Waiting for Start Button");
						await driver.waitFor(startButton, timeout: Duration(seconds: 60*3));
						await driver.tap(startButton);

						print("Waiting for Close Button");
						if (await isPresent(closeButton, driver)) {
							await driver.tap(closeButton);
						} else {

							try {

								print("Waiting for Next Button");
								await driver.waitFor(nextButton);
								await driver.tap(nextButton);
							} catch(e) {

							}

						}
					}
				});
			} catch(e) {
				print(e.toString());
			}

		});
		
	});
}

isPresent(SerializableFinder byValueKey, FlutterDriver driver, {Duration timeout = const Duration(seconds: 1)}) async {
	try {
		await driver.waitFor(byValueKey,timeout: timeout);
		return true;
	} catch(exception) {
		return false;
	}
}
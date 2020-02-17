
import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:pulse_search/src/configs/search_configs.dart';
import 'package:pulse_search/src/data/waiting_status.dart';
import 'package:test/test.dart';

void main() {
	group("Pulse Search using bloc", () {
		FlutterDriver driver;

		// UI
		final beginButton = find.byValueKey("home_screen_begin_button");
		final backButton = find.byValueKey("search_screen_back_button");
		final skipButton = find.byValueKey("search_screen_skip_button");
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


		test("#1 Full flow", () async {
			try {
				final random = Random();
				await driver.waitFor(beginButton);
				await driver.tap(beginButton);

				await driver.runUnsynchronized(() async {

					while (true) {
						bool isCloseButtonPresent = false;

						// Back
						if (random.nextBool()) {
							print("Waiting for 'Back Button'");
							await driver.waitFor(backButton);
							await driver.tap(backButton);

							print("Waiting for 'Begin Button'");
							await driver.waitFor(beginButton);
							await driver.tap(beginButton);
							continue;
						}

						// Skip
						if (random.nextBool()) {

							print("Waiting for 'Skip Button'");
							await driver.waitFor(skipButton, timeout: Duration(seconds: 60));
							await driver.tap(skipButton);
							continue;
						}


						// Waiting
						if (random.nextBool()) {
							print("Waiting for 'Back Button' (Waiting)");
							await driver.waitFor(backButton, timeout: SearchConfigs.waitingForResponseTimeout);
							continue;
						}

						// Start
						print("Waiting for 'Start Button'");
						await driver.waitFor(startButton, timeout: Duration(seconds: 60));
						await driver.tap(startButton);


						print("Waiting for 'Close Button'");
						isCloseButtonPresent = await isPresent(
							closeButton, driver,
							timeout: Duration(seconds: 5));
						if (isCloseButtonPresent) {
							await driver.tap(closeButton);
						} else {

							if (random.nextBool()) {

								print("Waiting for 'Next Button'");
								await driver.waitFor(nextButton);
								await driver.tap(nextButton);
								await Future.delayed(Duration(seconds: 1));
								continue;
							}

							print("Waiting for 'End Button'");
							await driver.waitFor(endButton);
							await driver.tap(endButton);

							print("Waiting for 'Begin Button'");
							await driver.waitFor(beginButton);
							await driver.tap(beginButton);
							continue;
						}

					}

				});

			} catch(e) {
				print(e.toString());
			}

		});
		
	}, timeout: Timeout(Duration(seconds: 60*60*24)));
}

isPresent(SerializableFinder byValueKey, FlutterDriver driver, {Duration timeout = const Duration(seconds: 1)}) async {
	try {
		await driver.waitFor(byValueKey,timeout: timeout);
		return true;
	} catch(exception) {
		return false;
	}
}
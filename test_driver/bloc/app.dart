import 'package:flutter_driver/driver_extension.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:pulse_search/locator.dart';
import 'package:pulse_search/main_bloc.dart' as app;
import 'package:pulse_search/src/core/response_error.dart';
import 'package:pulse_search/src/data/user_pool.dart';
import 'package:pulse_search/src/models/matching_info.dart';
import 'package:pulse_search/src/services/matching_service.dart';
import 'package:pulse_search/src/services/notification_service.dart';

import '../services/matching_service.dart';

void main() {
	enableFlutterDriverExtension(handler: (message) async {
		switch (message) {
			case "MatchingService.search()->error":
				when(locator.get<MatchingService>().search())
					.thenThrow(ResponseError("Search error"));
				break;

			case "NotificationService.fire()->match_found":
				locator.get<NotificationService>().fire(Notification(
					identifier: "match_found",
					payload: MatchingInfo(
						id: 1,
						matchedUser: pool[0],
						token: "asdsd"
					)
				));
				break;
		}
		return "";
	});

	//
	locator.allowReassignment = true;
	app.main();
//	locator.registerFactory<MatchingService>(() => MockMatchingService());
	locator.registerSingleton(Logger(level: Level.nothing));
}
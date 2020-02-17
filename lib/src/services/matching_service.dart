import 'dart:math';

import 'package:pulse_search/locator.dart';
import 'package:pulse_search/src/core/response_error.dart';
import 'package:pulse_search/src/data/user_pool.dart' as data;
import 'package:pulse_search/src/models/matching_info.dart';
import 'package:pulse_search/src/services/notification_service.dart';

abstract class MatchingService {
	Future<void> search();

	Future<void> skip(int id);
}

class DefaultMatchingService implements MatchingService {
	@override
	Future<void> search() async {
		final random = Random();
		var duration = Duration(milliseconds: random.nextInt(2000));
		await Future.delayed(duration);

		if (random.nextBool())
			throw ResponseError("Something went wrong when searching");

		final index = random.nextInt(data.pool.length - 1);
		final user = data.pool[index];
		final match = MatchingInfo(id: random.nextInt(100), matchedUser: user, token: "axmoasdk");
		final service = locator.get<NotificationService>();
		var firedDate = DateTime.now().add(Duration(seconds: random.nextInt(10)));

		var notification = Notification(identifier: "matching_found");
		notification.payload = match;
		service.schedule(notification, firedDate);

		// Schedule another notification "skip by matched user"
		if (random.nextBool()) {
			notification = Notification(identifier: "matching_skiped_by_other");
			notification.payload = { "id": match.id };
			firedDate = firedDate.add(Duration(seconds: random.nextInt(3)));
			service.schedule(notification, firedDate);
		}

	}

	@override
	Future<void> skip(int id) async {
		final random = Random();
		final duration = Duration(milliseconds: random.nextInt(2000));
		await Future.delayed(duration);

		if (random.nextBool())
			throw ResponseError("Unable to skip");
	}
}

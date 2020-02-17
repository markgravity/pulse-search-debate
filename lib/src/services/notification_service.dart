import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:pulse_search/src/core/logger.dart';

class Notification {
	String identifier;
	dynamic payload;

	Notification({@required this.identifier, this.payload});

	@override
    String toString() {
        return payload.toString();
    }
}

abstract class NotificationService {
	//
	void fire(Notification notification);
	void schedule(Notification notification, DateTime firedDate);
	Future<Notification> listen(String identifier);
}

class DefaultNotificationService implements NotificationService {
	final _eventBus = EventBus();

	@override
	Future<Notification> listen(String identifier) async {
		await for(Notification notification in _eventBus.on<Notification>()) {
			if (notification.identifier == identifier){
				logger.d("Notification Listened: ${notification.identifier} ${notification.payload.toString()}");
				return notification;
			}

		}
	}

	@override
	void fire(Notification notification) {
		logger.d("Notification Fired: ${notification.identifier}");
		_eventBus.fire(notification);
	}

	@override
	void schedule(Notification notification, DateTime firedDate) async {
		await Future.delayed(firedDate.difference(DateTime.now()));
		fire(notification);
	}
}

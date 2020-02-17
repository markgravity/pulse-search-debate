import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:pulse_search/src/blocs/bloc.dart';
import 'package:pulse_search/src/blocs/status/bloc.dart';
import 'package:pulse_search/src/services/matching_service.dart';
import 'package:pulse_search/src/services/notification_service.dart';
import 'package:pulse_search/src/services/twilio_video_service.dart';

final locator = GetIt.instance;

void configureLocator() {
	locator.registerSingleton<NotificationService>(DefaultNotificationService());
	locator.registerSingleton<Logger>(Logger());

	locator.registerFactory<MatchingService>(() => DefaultMatchingService());
	locator.registerFactory<TwilioVideoService>(() => DefaultTwilioVideoService());
	locator.registerFactory<SearchStatusBloc>(() => SearchStatusBloc());

	locator.registerFactory<SearchBloc>(() => SearchBloc(
		notiService: locator.get<NotificationService>(),
		matchingService: locator.get<MatchingService>(),
		twilioVideoService: locator.get<TwilioVideoService>(),
		statusBloc: locator.get<SearchStatusBloc>()
	));
}
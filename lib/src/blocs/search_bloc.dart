import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_search/src/blocs/status/bloc.dart';
import 'package:pulse_search/src/configs/search_configs.dart';
import 'package:pulse_search/src/core/logger.dart';
import 'package:pulse_search/src/core/response_error.dart';
import 'package:pulse_search/src/core/timer_dispose_bag.dart';
import 'package:pulse_search/src/data/waiting_status.dart';
import 'package:pulse_search/src/models/matching_info.dart';
import 'package:pulse_search/src/services/matching_service.dart';
import 'package:pulse_search/src/services/notification_service.dart';
import 'package:pulse_search/src/services/twilio_video_service.dart';
import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(
      {@required this.statusBloc,
      @required this.notiService,
      @required this.matchingService,
      @required this.twilioVideoService});

  //
  Timer _changeSearchingStatusTimer;
  Timer _waitingForResponseTimer;
  int _searchingStatusIndex = 0;

  final SearchStatusBloc statusBloc;
  final _timerDisposeBag = TimerDisposeBag();
  final _searchingStatusInterval = SearchConfigs.searchingStatusInterval;
  final _waitingForResponseTimeout = SearchConfigs.waitingForResponseTimeout;
  final _countDownDuration = SearchConfigs.countDownDuration;
  final NotificationService notiService;
  final MatchingService matchingService;
  final TwilioVideoService twilioVideoService;

  @override
  SearchState get initialState => SearchInitialState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    logger.d("Map event: $event");

    final state = this.state;

    // Begin counting down (3..2..1)
    // then begin SearchSearchEvent
    if (event is SearchStartedEvent) {
      _scheduleCountingDownStatus();
    }

    // Begin search
    else if (event is SearchSearchEvent) {
      yield SearchSearchingState();
      _scheduleChangeSearchingStatus();

      try {
        // Search
        await matchingService.search();
        logger.d("Event: Search registered");

        // Found user
        final notification = await notiService.listen("matching_found");
        logger.d("Event: Match found ${notification.payload}");

        // Update status
        final matching = notification.payload as MatchingInfo;
        yield SearchWaitingForResponseState(matching: matching);
        _scheduleWaitingForResponseTimeoutEvent();

        logger.d("Event: Listen skip by other");
        _listenSkipByOtherNotifications();
      } catch (e) {
        logger.d("Error: ${e.toString()}");
        add(SearchSearchEvent());
      }
    }

    // Start connect to room
    else if (event is SearchStartEvent &&
        state is SearchWaitingForResponseState) {
      _waitingForResponseTimer?.cancel();
      statusBloc.add(SearchStatusChangeContentEvent(content: "Connecting"));
      final matching = state.matching;

      try {
        // Connect to Twilio Service
        await twilioVideoService.connect(token: matching.token);
        yield SearchConnectedState(matching: matching);
      } catch (e) {
        if (e is ResponseError) {
          yield SearchErrorState(message: e.message);
          return;
        }

        throw e;
      }
    }

    // Skip current matched user
    else if (event is SearchSkipEvent &&
        state is SearchWaitingForResponseState) {
      _waitingForResponseTimer?.cancel();
      matchingService.skip(state.matching.id).then((_) {}).catchError((_) {});

      // Research
      add(SearchSearchEvent());
    }

    // Back to home
    else if (event is SearchBackEvent) {
      // Kill all timer for sure
      _timerDisposeBag.dispose();

      yield SearchReadyToBackState();
    }
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    if (error is! StateError) throw error;
  }

  @override
  void onTransition(Transition<SearchEvent, SearchState> transition) {
    logger.d(transition);
    super.onTransition(transition);
  }

  @override
  Future<void> close() {
    _timerDisposeBag.dispose();
    return super.close();
  }

  // Private
  void _scheduleCountingDownStatus() {
    int seconds = _countDownDuration.inSeconds;
    statusBloc
        .add(SearchStatusChangeContentEvent(content: "Begin in $seconds"));

    Timer.periodic(Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds <= 0) {
        timer.cancel();
        add(SearchSearchEvent());
        return;
      }

      statusBloc
          .add(SearchStatusChangeContentEvent(content: "Begin in $seconds"));
    }).addTo(disposeBag: _timerDisposeBag);
  }

  void _scheduleChangeSearchingStatus() {
    // Guard current state
    if (state is! SearchSearchingState) return;

    // Stop previous timer
    _changeSearchingStatusTimer?.cancel();

    // Initial content
    statusBloc.add(SearchStatusChangeContentEvent(
        content: waitingStatus[_searchingStatusIndex]));

    _changeSearchingStatusTimer =
        Timer.periodic(_searchingStatusInterval, (timer) {
      // Guard current state
      if (state is! SearchSearchingState) {
        timer.cancel();
        return;
      }

      // Increase index
      _searchingStatusIndex++;

      // Guard index value
      if (_searchingStatusIndex >= waitingStatus.length) {
        _searchingStatusIndex = 0;
      }

      // Fire change status event
      statusBloc.add(SearchStatusChangeContentEvent(
          content: waitingStatus[_searchingStatusIndex]));
    })
          ..addTo(disposeBag: _timerDisposeBag);
  }

  void _scheduleWaitingForResponseTimeoutEvent() {
    if (state is! SearchWaitingForResponseState) return;

    int seconds = _waitingForResponseTimeout.inSeconds;
    statusBloc.add(SearchStatusChangeContentEvent(
        content: "Waiting for your response (${seconds}s)"));
    _waitingForResponseTimer?.cancel();
    _waitingForResponseTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state is! SearchWaitingForResponseState) {
        timer.cancel();
        return;
      }

      // Increase seconds
      seconds--;
      if (seconds <= 0) {
        timer.cancel();
        add(SearchSkipEvent(
            id: (state as SearchWaitingForResponseState).matching.id));
        return;
      }

      // Update status
      statusBloc.add(SearchStatusChangeContentEvent(
          content: "Waiting for your response (${seconds}s)"));
    })
      ..addTo(disposeBag: _timerDisposeBag);
  }

  void _listenSkipByOtherNotifications() {
    notiService.listen("matching_skip_by_other").then((notification) {
      final state = this.state;
      if (state is SearchStateHasMatching &&
          notification.payload.id == state.matching.id)
        add(SearchSearchEvent());
    });
  }
}

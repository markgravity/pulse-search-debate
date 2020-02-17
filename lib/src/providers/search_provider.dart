import 'dart:async';

import 'package:pulse_search/src/providers/loading_error_provider.dart';

import '../configs/search_configs.dart';
import '../core/response_error.dart';
import '../data/waiting_status.dart';
import '../models/matching_info.dart';
import '../services/matching_service.dart';
import '../services/notification_service.dart';
import '../services/twilio_video_service.dart';
import 'helpers.dart';

class SearchProvider extends LoadingErrorProvider {
  Timer _changeSearchingStatusTimer;
  Timer _waitingForResponseTimer;

  // DEPENDENCIES
  final MatchingService matchingService;
  final NotificationService notiService;
  final TwilioVideoService twilioVideoService;

  // CONSTRUCTOR
  SearchProvider(
      {this.twilioVideoService, this.matchingService, this.notiService});

  // STATES
  SearchState _searchState = SearchState.BEGIN;
  String _hintText = '';
  MatchingInfo _matchingInfo;

  SearchState get searchState => _searchState;

  String get hintText => _hintText;

  MatchingInfo get matchingInfo => _matchingInfo;

  // METHODS
  void waitingForBegin() {
    int seconds = SearchConfigs.countDownDuration.inSeconds;
    _matchingInfo = null;
    _searchState = SearchState.BEGIN;
    _hintText = getWaitingTextInSc(seconds);
    notifyListeners();

    Timer.periodic(Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds <= 0) {
        doSearching();
        timer.cancel();
        return;
      }

      _hintText = getWaitingTextInSc(seconds);
      notifyListeners();
    });
  }

  //
  Future<void> doSearching() async {
    changeError(null);
    _searchState = SearchState.SEARCHING;
    _matchingInfo = null;
    notifyListeners();
    _scheduleChangeHintText();

    try {
      // Search
      await matchingService.search();

      // Found user
      final notification = await notiService.listen("matching_found");

      // Update status
      final matching = notification.payload as MatchingInfo;
      _searchState = SearchState.WAITING;
      _matchingInfo = matching;
      notifyListeners();

      _scheduleWaitingForResponseTimeoutEvent();

      _listenSkipByOtherNotifications();
    } catch (e) {
      doSearching();
    }
  }

  void skipMatch() {
    _waitingForResponseTimer?.cancel();
    if (_matchingInfo != null)
      matchingService.skip(_matchingInfo.id).then((_) {}).catchError((_) {});
    doSearching();
  }

  Future<void> startMatch() async {
    _waitingForResponseTimer?.cancel();
    _hintText = 'Connecting';
    notifyListeners();

    try {
      await twilioVideoService.connect(token: _matchingInfo.token);
      _searchState = SearchState.CONNECTED;
      notifyListeners();
    } catch (e) {
      if (e is ResponseError) {
        changeError(ResponseError('Somrthing wrong. T___T'));
        return;
      }

      throw e;
    }
  }

  //
  void _scheduleChangeHintText() async {
    if (_searchState != SearchState.SEARCHING) return;

    _changeSearchingStatusTimer?.cancel();

    int searchingStatusIndex = 0;
    _hintText = waitingStatus[searchingStatusIndex];
    notifyListeners();

    _changeSearchingStatusTimer = Timer.periodic(
      SearchConfigs.searchingStatusInterval,
      (timer) {
        // Guard current state
        if (_searchState != SearchState.SEARCHING) {
          timer.cancel();
          return;
        }

        // Increase index
        searchingStatusIndex++;

        // Guard index value
        if (searchingStatusIndex >= waitingStatus.length) {
          searchingStatusIndex = 0;
        }

        _hintText = waitingStatus[searchingStatusIndex];
        notifyListeners();
      },
    );
  }

  //
  void _scheduleWaitingForResponseTimeoutEvent() {
    if (_searchState != SearchState.WAITING) return;

    int seconds = SearchConfigs.waitingForResponseTimeout.inSeconds;

    _hintText = getWaitingForResponseText(seconds);
    notifyListeners();

    _waitingForResponseTimer?.cancel();
    _waitingForResponseTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_searchState != SearchState.WAITING) {
        timer.cancel();
        return;
      }

      // Increase seconds
      seconds--;
      if (seconds <= 0) {
        skipMatch();
        timer.cancel();
        return;
      }

      _hintText = getWaitingForResponseText(seconds);
      notifyListeners();
    });
  }

  //
  void _listenSkipByOtherNotifications() {
    notiService.listen("matching_skiped_by_other").then((notification) {
      if (searchState == SearchState.WAITING &&
          notification.payload['id'] == _matchingInfo.id) {
        _matchingInfo = null;
        doSearching();
      }
    });
  }

  //
  void cancelAllTimer() {
    _matchingInfo = null;
    _changeSearchingStatusTimer?.cancel();
    _waitingForResponseTimer?.cancel();
  }
}

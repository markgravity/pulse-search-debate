String getWaitingTextInSc(int seconds) => 'Begin in ${seconds}s';

String getWaitingForResponseText(int seconds) =>
    'Waiting for your response (${seconds}s)';

enum SearchState {
  BEGIN,
  SEARCHING,
  WAITING,
  CONNECTING,
  CONNECTED,
}

const canGoBackStates = [SearchState.BEGIN, SearchState.SEARCHING];

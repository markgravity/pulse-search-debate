import 'dart:async';

class TimerDisposeBag {
	//
	var _disposables = List<Timer>();
	void dispose() {
		_disposables.forEach((o) => o.cancel());
	}

	void add(Timer timer) {
		_disposables.add(timer);
	}


}

extension DisposeBag on Timer {
	void addTo({ TimerDisposeBag disposeBag }) {
		disposeBag.add(this);
	}
}
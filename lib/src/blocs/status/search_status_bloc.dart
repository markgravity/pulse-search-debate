import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class SearchStatusBloc extends Bloc<SearchStatusEvent, SearchStatusState> {
	@override
	SearchStatusState get initialState => SearchStatusContentChangedState(content: "");

	@override
	Stream<SearchStatusState> mapEventToState(
		SearchStatusEvent event,
		) async* {

		if (event is SearchStatusChangeContentEvent) {
			yield SearchStatusContentChangedState(content: event.content);
		}
	}
}

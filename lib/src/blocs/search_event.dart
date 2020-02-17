import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pulse_search/src/models/matching_info.dart';

abstract class SearchEvent extends Equatable {
	const SearchEvent();
}

class SearchStartedEvent extends SearchEvent {
	@override
	List<Object> get props => null;
}

class SearchSearchEvent extends SearchEvent {
	@override
    List<Object> get props => null;
}

class SearchSearchFoundEvent extends SearchEvent {
	SearchSearchFoundEvent({ @required this.matching });

	//
	final MatchingInfo matching;

	@override
	List<Object> get props => [matching];
}

class SearchStartEvent extends SearchEvent {
	@override
	List<Object> get props => null;
}

class SearchSkipEvent extends SearchEvent {
	SearchSkipEvent({ @required this.id });

	//
	final int id;
	@override
	List<Object> get props => [id];
}

class SearchCancelEvent extends SearchEvent {

	//
	@override
	List<Object> get props => null;
}

class SearchBackEvent extends SearchEvent {
	@override
	List<Object> get props => null;
}

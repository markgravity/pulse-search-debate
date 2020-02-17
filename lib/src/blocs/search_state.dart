import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pulse_search/src/models/matching_info.dart';

abstract class SearchState extends Equatable {
	const SearchState();
}

class SearchStateHasMatching extends SearchState {
	SearchStateHasMatching({ @required this.matching });

	//
	final MatchingInfo matching;
	@override
	List<Object> get props => [matching];
}

class SearchStateHasAvatar extends SearchState {
	SearchStateHasAvatar({ @required this.avatarImage });

	//
	final ImageProvider avatarImage;
	@override
	List<Object> get props => [avatarImage];
}

class SearchInitialState extends SearchState implements SearchStateHasAvatar {

	final ImageProvider avatarImage = AssetImage("unknown.png");
	@override
	List<Object> get props => [avatarImage];
}

class SearchSearchingState extends SearchState implements SearchStateHasAvatar {

	final ImageProvider avatarImage = AssetImage("unknown.png");
	//
	@override
	List<Object> get props => [avatarImage];
}

class SearchWaitingForResponseState extends SearchState implements SearchStateHasMatching, SearchStateHasAvatar {
	SearchWaitingForResponseState({ @required this.matching });

	//
	ImageProvider get avatarImage => matching.matchedUser.avatarImage;
	final MatchingInfo matching;

	@override
	List<Object> get props => [matching];
}

class SearchConnectingState extends SearchState implements SearchStateHasMatching {
	SearchConnectingState({ @required this.matching });

	//
	final MatchingInfo matching;

	@override
	List<Object> get props => [matching];
}

class SearchConnectedState extends SearchState implements SearchStateHasMatching {
	SearchConnectedState({ @required this.matching });

	//
	final MatchingInfo matching;

	@override
	List<Object> get props => [matching];
}

class SearchErrorState extends SearchState {
	SearchErrorState({ @required this.message });

	//
	final String message;

	@override
	List<Object> get props => [message];
}

class SearchReadyToBackState extends SearchState {
	@override
	List<Object> get props => [];
}

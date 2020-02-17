import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class SearchStatusState extends Equatable {
	const SearchStatusState();
}

class SearchStatusContentChangedState extends SearchStatusState {
	SearchStatusContentChangedState({ @required this.content });

	//
	final String content;

	@override
	List<Object> get props => [content];
}

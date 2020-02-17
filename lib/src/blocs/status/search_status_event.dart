import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchStatusEvent extends Equatable {
	const SearchStatusEvent();
}

class SearchStatusChangeContentEvent extends SearchStatusEvent {
	SearchStatusChangeContentEvent({ @required this.content });

	//
	final String content;
	@override
    List<Object> get props => [content];
}

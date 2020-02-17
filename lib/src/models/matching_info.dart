import 'package:flutter/cupertino.dart';
import 'package:pulse_search/src/models/user_info.dart';

class MatchingInfo {
	//
	int id;
	UserInfo matchedUser;
	String token;

	MatchingInfo({
		@required this.id,
		@required this.matchedUser,
		@required this.token
	});

	@override
    String toString() => "$id";
}

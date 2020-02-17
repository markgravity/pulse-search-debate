import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class UserInfo {
	//
	int id;
	String name;
	String avatarUrl;
	ImageProvider get avatarImage => NetworkImage(avatarUrl);

	UserInfo({
		@required this.id,
		@required this.name,
		@required this.avatarUrl,
	});
}
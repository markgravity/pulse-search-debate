import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
	//
	@override
    State<StatefulWidget> createState() => ScreenState();
}

class ScreenState extends State<Screen> {
	@override
    void initState() {
        super.initState();


        // Alert dialog
        showDialog(
	        context: context,
	        child: AlertDialog(
		        content: Text(""),
		        actions: <Widget>[
			        FlatButton(
				        key: Key("search_screen_close_button"),
				        child: Text('Close'),
				        onPressed: () {
					        Navigator.of(context).pop();
				        },
			        ),
		        ],
	        )
        );
    }


	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>[
						Container(
							width: 120,
							height: 120,
							child: CircleAvatar(
								child: Image.asset("unknown.png"),
							),
						),
						const SizedBox(height: 20,),
						Container(
							width: 270,
							child: Text(
								"We’re looking all the world to find you the right one….",
								key: Key("search_screen_status_text"),
								textAlign: TextAlign.center,
							),
						),
						const SizedBox(height: 20,),
						CircularProgressIndicator(),
						const SizedBox(height: 20,),
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								RaisedButton(
									key: Key("search_screen_back_button"),
									onPressed: () {},
									child: Text("Back"),
								),
								const SizedBox(width: 8,),
								RaisedButton(
									key: Key("search_screen_skip_button"),
									onPressed: () {},
									child: Text("Skip"),
								),
								const SizedBox(width: 8,),
								RaisedButton(
									key: Key("search_screen_start_button"),
									onPressed: () {},
									child: Text("Start"),
								),

							],
						)
					],
				),
			),
		);
	}
}
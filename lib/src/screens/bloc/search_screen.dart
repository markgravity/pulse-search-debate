import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_search/src/blocs/bloc.dart';
import 'package:pulse_search/src/blocs/status/bloc.dart';
import 'package:pulse_search/src/screens/call_screen.dart';

class Screen extends StatefulWidget {
	//
	@override
    State<StatefulWidget> createState() => ScreenState();
}

class ScreenState extends State<Screen> {
	SearchBloc _bloc;

	@override
    void didChangeDependencies() {
        super.didChangeDependencies();

        _bloc = BlocProvider.of<SearchBloc>(context);
        _bloc.add(SearchStartedEvent());
    }

	@override
    Widget build(BuildContext context) {

        return BlocListener<SearchBloc, SearchState>(
	        listener: (context, state) async {
				if (state is SearchReadyToBackState) {
					Navigator.pop(context);
				}

				else if (state is SearchErrorState) {
					await showDialog(
						context: context,
						child: AlertDialog(
							content: Text("${state.message}"),
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
					_bloc.add(SearchSearchEvent());
				}

				if (state is SearchConnectedState) {
					Navigator.pushReplacement(context, MaterialPageRoute(builder: (content) => CallScreen()));
				}
	        },
	        child: Scaffold(
		        body: Center(
			        child: Column(
				        mainAxisAlignment: MainAxisAlignment.center,
				        crossAxisAlignment: CrossAxisAlignment.center,
				        children: <Widget>[
					        _buildAvatarUI(),
					        _buildNameUI(),
					        const SizedBox(height: 20,),
					        _buildStatusUI(),
					        const SizedBox(height: 20,),
					        _buildProgressIndicatorUI(),
					        const SizedBox(height: 20,),
			                _buildActionsUI()
				        ],
			        ),
		        ),
	        ),
        );
    }

    Widget _buildProgressIndicatorUI() {
		return BlocBuilder<SearchBloc, SearchState>(
			condition: (_, state) => state is! SearchInitialState,
			builder: (_, state) {
				return CircularProgressIndicator();
			},
		);
    }

    Widget _buildStatusUI() {

		return Container(
			width: 270,
			height: 50,
			child:
			BlocBuilder<SearchStatusBloc, SearchStatusState>(
				bloc: _bloc.statusBloc,
				builder: (_, state) {
					return Text(
						(state as SearchStatusContentChangedState).content,
						key: Key("search_screen_status_text"),
						textAlign: TextAlign.center,
					);
				},
			),
		);
    }
    Widget _buildAvatarUI() {

		return Container(
			width: 120,
			height: 120,
			child: CircleAvatar(
				child: BlocBuilder<SearchBloc, SearchState>(
					condition: (prevState, state) {
						return state is SearchStateHasAvatar;
					},
					builder: (_, state) {
						return Image(image: (state as SearchStateHasAvatar).avatarImage,);
					},
				),
			),
		);
    }
    Widget _buildNameUI() {
		return BlocBuilder<SearchBloc, SearchState>(
			condition: (_, state) => state is SearchSearchingState || state is SearchWaitingForResponseState,
			builder: (_, state) {
				return state is SearchWaitingForResponseState ?
				Container(
					margin: EdgeInsets.only(top: 8),
					child: Text(state.matching.matchedUser.name),
				) : SizedBox.shrink();
			},
		);
    }

    Widget _buildActionsUI() {

		return BlocBuilder<SearchBloc, SearchState>(
			condition: (_, state) {
				return state is SearchInitialState
					|| state is SearchSearchingState
					|| state is SearchWaitingForResponseState
					|| state is SearchConnectingState;
			},
			builder: (_, state) {

				if (state is SearchInitialState || state is SearchSearchingState) {
					return RaisedButton(
						key: Key("search_screen_back_button"),
						onPressed: () {
							Navigator.pop(context);
						},
						child: Text("Back"),
					);
				}

				else if (state is SearchWaitingForResponseState) {
					return Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							RaisedButton(
								key: Key("search_screen_skip_button"),
								onPressed: () => _bloc.add(SearchSkipEvent(id: state.matching.id)),
								child: Text("Skip"),
							),
							const SizedBox(width: 8,),
							RaisedButton(
								key: Key("search_screen_start_button"),
								onPressed: () => _bloc.add(SearchStartEvent()),
								child: Text("Start"),
							),

						],
					);
				} else if (state is SearchConnectingState) {

					return RaisedButton(
						key: Key("search_screen_cancel_button"),
						onPressed: () => _bloc.add(SearchCancelEvent()),
						child: Text("Cancel"),
					);
				}

				return null;
			},
		);
    }
}
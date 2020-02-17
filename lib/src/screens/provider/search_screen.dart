import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_search/src/providers/helpers.dart';
import 'package:pulse_search/src/providers/search_provider.dart';
import 'package:pulse_search/src/screens/provider/error_dialog.dart';

class Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<SearchProvider>(context, listen: false).waitingForBegin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildAvatar(),
            const SizedBox(
              height: 20,
            ),
            _buildHintText(),
            const SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            _buildButtons(),
            _buildErrorDialogAndNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Selector<SearchProvider, dynamic>(
      selector: (_, provider) => provider.matchingInfo,
      builder: (_, info, __) {
        if (info == null)
          return Container(
            width: 120,
            height: 120,
            child: CircleAvatar(
              child: Image.asset("unknown.png"),
            ),
          );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 120,
              height: 120,
              child: CircleAvatar(
                child: Image(
                  image: info.matchedUser.avatarImage,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(info.matchedUser.name),
          ],
        );
      },
    );
  }

  Widget _buildHintText() {
    return Selector<SearchProvider, String>(
      selector: (_, provider) => provider.hintText,
      builder: (_, text, __) {
        return Container(
          width: 270,
          child: Text(
            text,
            key: Key("search_screen_status_text"),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildButtons() {
    return Selector<SearchProvider, SearchState>(
      selector: (_, provider) => provider.searchState,
      builder: (_, state, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (canGoBackStates.contains(state)) ...[
            RaisedButton(
              key: Key("search_screen_back_button"),
              onPressed: () {
                Provider.of<SearchProvider>(context, listen: false)
                    .cancelAllTimer();
                Navigator.of(context).pop();
              },
              child: Text("Back"),
            ),
            const SizedBox(
              width: 8,
            )
          ],
          if (!canGoBackStates.contains(state)) ...[
            RaisedButton(
              key: Key("search_screen_skip_button"),
              onPressed: () {
                Provider.of<SearchProvider>(context, listen: false).skipMatch();
              },
              child: Text("Skip"),
            ),
            const SizedBox(
              width: 8,
            ),
            RaisedButton(
              key: Key("search_screen_start_button"),
              onPressed: () {
                Provider.of<SearchProvider>(context, listen: false)
                    .startMatch();
              },
              child: Text("Start"),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildErrorDialogAndNavigation() {
    return Selector<SearchProvider, List>(
      selector: (_, provider) =>
          [provider.error, provider.doSearching, provider.searchState],
      builder: (_, data, __) {
        return ErrorDialog(
          error: data[0],
          backFunction: data[1],
          searchState: data[2],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pulse_search/app.dart';
import 'package:pulse_search/locator.dart';
import 'package:pulse_search/src/core/environment.dart';

void main(){
	configureLocator();
	runApp(App(env: Environment.provider,));
}



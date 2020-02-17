import 'package:flutter/material.dart';

class LoadingErrorProvider with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  Error _error;

  Error get error => _error;

  void changeLoading(bool loading) {
    _loading = loading;
  }

  void changeError(Error error) {
    _error = error;
  }
}

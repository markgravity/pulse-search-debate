import 'dart:math';

import 'package:pulse_search/src/core/response_error.dart';

abstract class TwilioVideoService {
  //
  Future<void> connect({String token});
}

class DefaultTwilioVideoService implements TwilioVideoService {
  @override
  Future<void> connect({String token}) async {
    final random = Random();
    final duration = Duration(milliseconds: random.nextInt(2000));
    await Future.delayed(duration);
    if (random.nextBool()) throw ResponseError("Failed to connect to room");
  }
}

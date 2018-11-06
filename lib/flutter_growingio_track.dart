import 'dart:async';

import 'package:flutter/services.dart';

class GrowingIO {
  static const MethodChannel _channel =
      const MethodChannel('flutter_growingio_track');

  static Future<Null> track(String eventId,
      {double num, Map<String, dynamic> variable}) async {
    Map<String, dynamic> args = {"eventId": eventId};
    if (num != null) {
      args['num'] = num;
    }
    if (variable != null) {
      args['variable'] = variable;
    }
    return await _channel.invokeMethod("track", args);
  }

  static Future<Null> setEvar(Map<String, dynamic> variable) async {
    return await _channel.invokeMethod("setEvar", variable);
  }

  static Future<Null> setPeopleVariable(Map<String, dynamic> variable) async {
    return await _channel.invokeMethod("setPeopleVariable", variable);
  }

  static Future<Null> setUserId(String userId) async {
    return await _channel.invokeMethod("setUserId", {"userId": userId});
  }

  static Future<Null> clearUserId() async {
    return await _channel.invokeMethod("clearUserId");
  }

  static Future<Null> setVisitor(Map<String, dynamic> variable) async {
    return await _channel.invokeMethod("setVisitor", variable);
  }
}

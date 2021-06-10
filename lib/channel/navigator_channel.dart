import 'package:flutter/services.dart';

/// 与原生路由交互渠道
/// 1.[getArguments] from native when open a Flutter page.
class NavigatorChannel {
  static const MethodChannel _channel = const MethodChannel('muffin_navigate');

  static Future<Map<String, dynamic>?> get arguments async {
    final dynamic arguments = await _channel.invokeMethod('getArguments');
    return Map.from(arguments);
  }

  static Future<dynamic> push(String pageName) async {
    return await _channel.invokeMethod('push', {'pageName': pageName});
  }

  static Future<dynamic> pop(String pageName, [dynamic result]) async {
    return await _channel
        .invokeMethod('pop', {'pageName': pageName, 'result': result});
  }

  static Future<dynamic> popUntil(String pageName, [dynamic result]) async {
    return await _channel
        .invokeMethod('popUntil', {'pageName': pageName, 'result': result});
  }

  static Future<String> findPopTarget() async {
    return await _channel.invokeMethod('findPopTarget');
  }
}

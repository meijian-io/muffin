import 'package:flutter/services.dart';
import 'package:muffin/core/muffin_main.dart';
import 'package:muffin/muffin.dart';

/// 与原生路由交互渠道
/// 1.[getArguments] from native when open a Flutter page.
class NavigatorChannel {
  static const MethodChannel _channel = const MethodChannel('muffin_navigate');

  static MethodChannel get channel => _channel;

  static Future<Map<String, dynamic>?> get arguments async {
    // final dynamic arguments = await _channel.invokeMethod('getArguments');
    final dynamic arguments = await invokeMethod('getArguments');
    return Map.from(arguments);
  }

  static Future<dynamic> get url async {
    // final dynamic url = await _channel.invokeMethod('getUrl');
    final dynamic url = await invokeMethod('getUrl');
    return url;
  }

  static Future<dynamic> syncFlutterStack(String pageName) async {
    // final dynamic call = await _channel.invokeMethod('syncFlutterStack', {'pageName': pageName})
    final dynamic call =
        await invokeMethod('syncFlutterStack', {'pageName': pageName});
    return call;
  }

  static Future<dynamic> pop(String pageName, [dynamic result]) async {
    // return await _channel.invokeMethod('pop', {'pageName': pageName, 'result': result});
    final dynamic call = await invokeMethod(
        'pop', {'pageName': pageName, 'result': result ?? {}});
    return call;
  }

  static Future<dynamic> popUntil(String pageName, [dynamic result]) async {
    // return await _channel.invokeMethod('popUntil', {'pageName': pageName, 'result': result});
    final dynamic call = await invokeMethod(
        'popUntil', {'pageName': pageName, 'result': result ?? {}});
    return call;
  }

  static Future<String> findPopTarget() async {
    // return await _channel.invokeMethod('findPopTarget');
    final dynamic call = await invokeMethod('findPopTarget');
    return call;
  }

  static Future<dynamic> pushNamed(String pageName, [dynamic data]) async {
    // return await _channel.invokeMethod('pushNamed', {'pageName': pageName, 'data': data});
    final dynamic call =
        await invokeMethod('pushNamed', {'pageName': pageName, 'data': data});
    return call;
  }

  ///when model be changed in flutter, sync to native
  static Future<dynamic> syncDataModel(Map<String, Object> map) async {
    // return await _channel.invokeMethod('syncDataModel', map);
    final dynamic call = await invokeMethod('syncDataModel', map);
    print(Map.from(call));
    return call;
  }

  /// model in Flutter should init when flutter start,
  static Future<Map<String, dynamic>?> initDataModel(String key) async {
    // final dynamic model = await _channel.invokeMethod('initDataModel', {'key': key});
    final dynamic model = await invokeMethod('initDataModel', {'key': key});
    return Map.from(model);
  }

  static Future<dynamic> invokeMethod(String key, [dynamic value]) async {
    try {
      return await _channel.invokeMethod(key, value);
    } catch (e, s) {
      print(e);
      print(s);
      return Muffin.onMockFunc(key, value);
    }
  }
}

import 'package:flutter/cupertino.dart';

///类似[RouteSettings]
///[Router]中每个[Route] 页面 配置信息
///之所以自定义，是因为之后可能对 [path] 的解析可能不同，每个使用者也可能不同
///TODO 提供一个 Decoder 给外部调用
class RouteConfig {
  final String? path;

  final dynamic arguments;

  RouteConfig({this.path, this.arguments});
}

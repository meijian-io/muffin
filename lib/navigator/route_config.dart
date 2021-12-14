import 'package:flutter/material.dart';
import 'package:muffin/navigator/page_route.dart';

///App 路由 页面的 配置信息，[MuffinRouterDelegate]，根据[currentPage] rebuild Navigator
///[Router]中每个[Route] 页面 配置信息
class RouteConfig extends RouteInformation {
  final List<MuffinPage> currentTreeBranch;

  ///正在或将要显示的 page，最终回调用[MuffinPageRoute]的 build 方法
  MuffinPage? get currentPage =>
      currentTreeBranch.isEmpty ? null : currentTreeBranch.last;

  RouteConfig({
    required this.currentTreeBranch,
    required String? location,
    required Object? state,
  }) : super(location: location, state: state);
}

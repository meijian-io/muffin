import 'package:flutter/material.dart';
import 'package:muffin_example/pages/country/country_view.dart';
import 'package:muffin_example/pages/details/details_view.dart';
import 'package:muffin_example/pages/home/home_binding.dart';
import 'package:muffin_example/pages/home/home_view.dart';

import 'app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
        name: Routes.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        children: [
          GetPage(
            name: Routes.COUNTRY,
            transition: Transition.leftToRight,
            page: () => CountryView(),
            children: [
              GetPage(
                name: Routes.DETAILS,
                page: () => DetailsView(),
              ),
            ],
          ),
        ]),
  ];
}

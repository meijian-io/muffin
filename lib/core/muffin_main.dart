import 'package:muffin/core/muffin_interface.dart';

///instead of MuffinNavigator.of()
class _Muffin extends MuffinInterface {}

// ignore: non_constant_identifier_names
final Muffin = _Muffin();

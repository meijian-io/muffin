import 'package:get/get.dart';

class HomeController extends SuperController {
  @override
  void onInit() {
    super.onInit();
    print('onInit called');
  }

  @override
  void onDetached() {
    print('onDetached called');
  }

  @override
  void onInactive() {
    print('onInactive called');
  }

  @override
  void onPaused() {
    print('onPaused called');
  }

  @override
  void onResumed() {
    print('onResumed called');
  }
}

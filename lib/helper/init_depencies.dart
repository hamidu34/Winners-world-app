import 'package:get/get.dart';
import 'package:winners_world_app/controller/auth_controller.dart';
import '/controller/tapcontroller.dart';

class InitDep implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => TapController());
  }
}

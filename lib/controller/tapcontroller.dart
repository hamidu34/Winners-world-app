import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TapController extends GetxController {
  static TapController controller = Get.find();

  RxInt _x = 0.obs;
  RxInt get x => _x;

  void increaseX() {
    _x++;
  }

  void decreaseX() {
    if (_x <= 0) {
      Get.snackbar('Cart item error', 'Selected item can\'t be less Zero',
          duration: const Duration(seconds: 3),
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
          colorText: Colors.white,
          isDismissible: true,
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      _x--;
    }
  }
}

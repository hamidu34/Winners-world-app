import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/controller/tapcontroller.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text('Shopping Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Books',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    TapController.controller.increaseX();
                  },
                  icon: const Icon(Icons.add),
                ),
                const Gap(20),
                Obx(
                  () => Container(
                    width: 35,
                    height: 25,
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Center(
                      child: Text(
                        TapController.controller.x.string,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    TapController.controller.decreaseX();
                  },
                  icon: const Icon(Icons.remove),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Container()),
                TextButton(
                    onPressed: () {
                      Get.bottomSheet(
                        Container(
                          width: double.maxFinite,
                          height: 300,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(90),
                                topRight: Radius.circular(90),
                              )),
                          child: Center(
                            child: Text(
                                '${TapController.controller.x.string} Total Item'),
                          ),
                        ),
                      );
                    },
                    child: const Text('Show Total'))
              ],
            )
          ],
        ),
      ),
    );
  }
}

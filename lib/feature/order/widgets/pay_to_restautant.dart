import 'package:stackfood_multivendor_driver/feature/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_driver/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/images.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../language/controllers/localization_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../domain/models/order_model.dart';
import 'slider_button_widget.dart';

class PayToRestaurant extends StatefulWidget {
  final double totalAmount;
  const PayToRestaurant({super.key, required this.totalAmount});

  @override
  State<PayToRestaurant> createState() => _PayToRestaurantState();
}

class _PayToRestaurantState extends State<PayToRestaurant> {
  @override
  Widget build(BuildContext context) {
    // orderController = Get.find<OrderController>().orderModel.
    OrderModel? controllerOrderModel = Get.find<OrderController>().orderModel;
    double amountPaid = widget.totalAmount;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(Images.money, height: 100, width: 100),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            "Slide to pay to restaurant",
            textAlign: TextAlign.center,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '${'order_amount'.tr}:',
              textAlign: TextAlign.center,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              PriceConverter.convertPrice(widget.totalAmount),
              textAlign: TextAlign.center,
              style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).primaryColor),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // CustomButtonWidget(
          //   buttonText: 'ok'.tr,
          //   onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute()),
          // ),

          controllerOrderModel!.orderStatus == 'paid'
              ? const Column(
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    Center(
                        child: Text(
                            "Please wait for restaurant to verify payment"))
                  ],
                )
              : SliderButtonWidget(
                  action: () {
                    // Get.back();
                    Get.find<OrderController>()
                        .updateDeliveryStatus(controllerOrderModel.id, 'paid',
                            amountPaid: amountPaid.toString())
                        .then((success) {
                      if (success) {
                        Get.find<OrderController>().getOrderWithId(controllerOrderModel.id);
                        Get.find<ProfileController>().getProfile();
                        Get.find<OrderController>().getCurrentOrders();
                      }
                    });
                  },
                  label: Text(
                    controllerOrderModel.orderStatus == 'handover'
                        ? "Swipe to Pay"
                        : '',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).primaryColor),
                  ),
                  dismissThresholds: 0.5,
                  dismissible: false,
                  shimmer: true,
                  width: 1170,
                  height: 60,
                  buttonSize: 50,
                  radius: 10,
                  icon: Center(
                      child: Icon(
                    Get.find<LocalizationController>().isLtr
                        ? Icons.double_arrow_sharp
                        : Icons.keyboard_arrow_left,
                    color: Colors.white,
                    size: 20.0,
                  )),
                  isLtr: Get.find<LocalizationController>().isLtr,
                  boxShadow: const BoxShadow(blurRadius: 0),
                  buttonColor: Theme.of(context).primaryColor,
                  backgroundColor: const Color(0xffF4F7FC),
                  baseColor: Theme.of(context).primaryColor,
                )
        ]),
      ),
    );
  }
}

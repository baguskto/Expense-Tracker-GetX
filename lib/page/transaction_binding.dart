import 'package:get/get.dart';
import 'package:hive_with_getx/page/transaction_controller.dart';

class TransactionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionController());
  }
}

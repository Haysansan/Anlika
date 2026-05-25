import 'package:get/get.dart';
import 'package:apploan/views/views.dart';

class LoanListsBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanListsController>(() => LoanListsController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<DisburmentListController>(() => DisburmentListController());
    Get.lazyPut<RepaymentController>(() => RepaymentController());
  }
}

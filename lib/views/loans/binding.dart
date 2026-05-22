import 'package:get/get.dart';
import 'package:apploan/views/views.dart';

class LoansDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoansDashboardController>(() => LoansDashboardController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<DisburmentListController>(() => DisburmentListController());
  }
}

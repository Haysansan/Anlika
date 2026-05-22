import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:apploan/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanDisbursmentsView extends GetView<LoanDisbursmentsController> {
  const LoanDisbursmentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.loanDisbursments.tr,
        onBack: () => Navigator.pop(context, false),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.red),
          );
        }
        return Padding(
          padding: UIConstants.spacing.padHorizontal,
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  UIConstants.spacing.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.choosestaff.tr,
                        style: AppTextStyle.normalPrimaryRegular,
                      ),
                      SearchDropDown<StaffModel>(
                        items: controller.StaffList,
                        itemAsString:
                            (item) =>
                                item.name
                                    .toString(), // Convert StaffModel to String
                        onChanged: (value) async {
                          await controller.onStaffChanged(value);
                        },
                        selectedItem: controller.StaffSelected,
                      ),
                    ],
                  ),
                  // Receiver phone number
                  // Column(
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: <Widget>[
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 "ប្រភេទកម្ចី",
                  //                 style: AppTextStyle.normalPrimaryRegular,
                  //               ),
                  //               SizedBox(height: 8), // Adjust height as needed
                  //               CustomDropdown(
                  //                 hintText: "ប្រភេទកម្ចី",
                  //                 items: controller.zones,
                  //                 validator: (text) => FormValidator.empty(text),
                  //                 onChanged: (value) {
                  //                   // Handle the value change
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         const SizedBox(width: 10,),
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 "ប្រភេទរយៈពេលខ្ចីប្រាក់",
                  //                 style: AppTextStyle.normalPrimaryRegular,
                  //               ),
                  //               SizedBox(height: 8), // Adjust height as needed
                  //               CustomDropdown(
                  //                 hintText: 'ប្រភេទរយៈពេលខ្ចីប្រាក់',
                  //                 items: controller.zones,
                  //                 validator: (text) => FormValidator.empty(text),
                  //                 onChanged: (value) {
                  //                   // Handle the value change
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // UIConstants.spacing.height,
                  // Destination zone
                  Obx(() {
                    if (controller.isLoading.value) {
                      // Display loading indicator when data is being fetched
                      return const Center(
                        child: CircularProgressIndicator(color: AppColor.red),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.product.tr,
                          style: AppTextStyle.normalPrimaryRegular,
                        ),
                        // SearchDropDown<ProductModel>(
                        //   items: controller.ProductList,
                        //   itemAsString: (item) =>
                        //       '${item.id} - ${item.name}', // Convert StaffModel to String
                        //   onChanged: (value) {
                        //     controller.onProductChanged(value as ProductModel?);
                        //   },
                        //   selectedItem: controller.ProductSelected,
                        // ),
                        SearchDropDown<ProductModel>(
                          items: controller.ProductList,
                          selectedItem: controller.ProductSelected,
                          itemAsString:
                              (ProductModel item) =>
                                  item.name, // tells dropdown how to display each item
                          onChanged: (ProductModel? selected) {
                            controller.onProductChanged(selected);
                            if (selected != null) {
                              controller.fetchProductDetail(selected.id);
                            }
                          },
                        ),
                      ],
                    );
                  }),
                  UIConstants.spacing.height,
                  Obx(() {
                    if (controller.isLoading1.value) {
                      // Display loading indicator when data is being fetched
                      return const Center(
                        child: CircularProgressIndicator(color: AppColor.red),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.chooseclients.tr,
                          style: AppTextStyle.normalPrimaryRegular,
                        ),
                        SearchDropDown(
                          items: controller.ClientList,
                          itemAsString:
                              (item) => '${item.client_code} - ${item.name}',
                          onChanged: (value) {
                            controller.onClientChanged(
                              value as ClientDisbModel?,
                            );
                          },
                          selectedItem: controller.clientSelected,
                        ),
                      ],
                    );
                  }),
                  UIConstants.spacing.height,
                  // Total amount
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.inst.tr,
                                  style: AppTextStyle.normalPrimaryRegular,
                                ),
                                2.height,
                                CustomTextField(
                                  controller: controller.instCtl,
                                  hintText: '\0.00',
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator:
                                      (text) => FormValidator.empty(text),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.principals.tr,
                                  style: AppTextStyle.normalPrimaryRegular,
                                ),
                                2.height,
                                CustomTextField(
                                  controller: controller.principlCtl,
                                  hintText: '\0.00',
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator:
                                      (text) => FormValidator.empty(text),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  UIConstants.spacing.height,
                  // Total amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.interast.tr,
                                  style: AppTextStyle.normalPrimaryRegular,
                                ),
                                2.height,
                                CustomTextField(
                                  controller: controller.intCtl,
                                  hintText: '\0.00',
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator:
                                      (text) => FormValidator.empty(text),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.fee.tr,
                                  style: AppTextStyle.normalPrimaryRegular,
                                ),
                                2.height,
                                CustomTextField(
                                  controller: controller.addminFeeCtl,
                                  hintText: '\0.00',
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator:
                                      (text) => FormValidator.empty(text),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Choose date
                  UIConstants.spacing.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.opendate.tr,
                        style: AppTextStyle.normalPrimaryRegular,
                      ),
                      2.height,
                      InkWell(
                        onTap: () => controller.getDatePicker().show(),
                        child: StackTextField(
                          controller: controller.dateOpenLoanCtl,
                          hintText: LocaleKeys.chooseDate.tr,
                          validator: (text) => FormValidator.phoneNumber(text),
                        ),
                      ),
                    ],
                  ),
                  UIConstants.spacing.height,
                  // Choose date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.firstdaterepayment.tr,
                        style: AppTextStyle.normalPrimaryRegular,
                      ),
                      2.height,
                      InkWell(
                        onTap: () => controller.getDateFirstPicker().show(),
                        child: StackTextField(
                          controller: controller.dateFirstRepaymentCtl,
                          hintText: LocaleKeys.chooseDate.tr,
                          validator: (text) => FormValidator.phoneNumber(text),
                        ),
                      ),
                    ],
                  ),
                  UIConstants.spacing.height,
                  // Submit
                  PrimaryButton(
                    text: LocaleKeys.submit.tr,
                    onPressed: () async {
                      if (!controller.formKey.currentState!.validate()) {
                        return;
                      }
                      controller.formKey.currentState!.save();
                      await controller.submitBooking();
                    },
                  ),

                  30.height,
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

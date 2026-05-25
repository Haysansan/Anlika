import 'package:flutter/material.dart';
import 'package:apploan/core/core.dart';

class ClientListView extends StatelessWidget {
  const ClientListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client List'),
        backgroundColor: AppColor.primary,
      ),
      // TODO: replace with real client list when implemented
      body: const Center(
        child: Text(
          'Client list coming soon',
          style: AppTextStyle.midPrimaryBold,
        ),
      ),
    );
  }
}

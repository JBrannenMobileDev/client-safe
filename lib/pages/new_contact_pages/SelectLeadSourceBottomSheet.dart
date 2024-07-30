import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

import 'LeadSourceBody.dart';

class SelectLeadSourceBottomSheet extends StatelessWidget {
  const SelectLeadSourceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: LeadSourceBody(),
      showPlusIcon: false,
      title: 'Select Lead Source',
      dialogHeight: 516,
      showActionButton: false,
    );
  }
}
import 'package:dandylight/pages/new_job_page/DateForm.dart';
import 'package:dandylight/pages/new_job_page/TimeSelectionForm.dart';
import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

class SelectStartTimeBottomSheet extends StatelessWidget {
  const SelectStartTimeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: TimeSelectionForm(),
      showPlusIcon: false,
      title: 'Select Start Time',
      dialogHeight: 532,
      showDoneButton: false,
    );
  }
}
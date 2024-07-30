import 'package:dandylight/pages/new_job_page/DateForm.dart';
import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

class SelectDateBottomSheet extends StatelessWidget {
  const SelectDateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: DateForm(),
      showPlusIcon: false,
      title: 'Select Session Date',
      dialogHeight: MediaQuery.of(context).size.height-64,
      showActionButton: true,
      actionButton: () {
        Navigator.of(context).pop();
      },
    );
  }
}
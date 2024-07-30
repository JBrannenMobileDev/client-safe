import 'package:dandylight/pages/new_job_page/JobTypeSelection.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

class SelectSessionTypeBottomSheet extends StatelessWidget {
  const SelectSessionTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: JobTypeSelection(),
      showPlusIcon: true,
      plusAction: () {
        NavigationUtil.showNewSessionTypePage(context, null);
      },
      title: 'Select Session Type',
      dialogHeight: MediaQuery.of(context).size.height*0.8,
      showActionButton: false,
    );
  }
}
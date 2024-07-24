import 'package:dandylight/pages/new_job_page/JobTypeSelection.dart';
import 'package:dandylight/pages/new_job_page/LocationSelectionForm.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

class SelectLocationBottomSheet extends StatelessWidget {
  const SelectLocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: LocationSelectionForm(),
      showPlusIcon: true,
      plusAction: () {
        UserOptionsUtil.showNewLocationDialog(context);
      },
      title: 'Select Location',
      dialogHeight: MediaQuery.of(context).size.height-64,
      showDoneButton: false,
    );
  }
}
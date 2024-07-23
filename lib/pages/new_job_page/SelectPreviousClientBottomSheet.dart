import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

import 'ClientSelectionForm.dart';

class SelectPreviousClientBottomSheet extends StatelessWidget {
  const SelectPreviousClientBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: ClientSelectionForm(),
      showPlusIcon: false,
      title: 'Select Client',
      dialogHeight: MediaQuery.of(context).size.height-64,
      showDoneButton: false,
    );
  }
}
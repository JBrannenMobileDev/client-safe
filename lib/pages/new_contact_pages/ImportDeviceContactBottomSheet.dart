import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

import 'ImportFromDeviceBody.dart';

class ImportDeviceContactBottomSheet extends StatelessWidget {
  const ImportDeviceContactBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: ImportFromDeviceBody(),
      showPlusIcon: false,
      title: 'Select Device Contact',
      dialogHeight: MediaQuery.of(context).size.height-64,
      showDoneButton: false,
    );
  }
}
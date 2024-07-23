import 'package:dandylight/pages/new_contact_pages/DeviceContactsPage.dart';
import 'package:dandylight/pages/new_contact_pages/NameAndGender.dart';
import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

class ImportDeviceContactBottomSheet extends StatelessWidget {
  const ImportDeviceContactBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: NameAndGender(),
      showPlusIcon: false,
      title: 'Select Device Contact',
      dialogHeight: MediaQuery.of(context).size.height-64,
      showDoneButton: false,
    );
  }
}
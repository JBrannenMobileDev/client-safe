import 'package:dandylight/models/SessionType.dart';
import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/NavigationUtil.dart';

class SessionTypeIncompleteWarningBottomSheet extends StatelessWidget {
  final SessionType sessionType;
  const SessionTypeIncompleteWarningBottomSheet({super.key, required this.sessionType});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: buildMessage(),
      showPlusIcon: false,
      title: 'Error - Cannot Create Job',
      dialogHeight: 254,
      showActionButton: true,
      actionButtonText: 'Update Session Type',
      actionButton: () {
        NavigationUtil.showNewSessionTypePage(context, sessionType);
      },
    );
  }

  Widget buildMessage() {
    return Container(
      alignment: Alignment.center,
      child: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        textAlign: TextAlign.center,
        text: 'The session type you have selected is incomplete. Please update your session type with a price.',
      ),
    );
  }
}
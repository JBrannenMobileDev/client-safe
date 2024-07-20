import 'package:dandylight/pages/new_session_type_page/NewSessionTypePageState.dart';
import 'package:dandylight/pages/new_session_type_page/ReminderSelectionWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import 'CustomJobStageBottomSheet.dart';
import 'DandyLightTextField.dart';
import 'JobStageSelectionForm.dart';


class ChooseRemindersBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ChooseRemindersBottomSheetState();
  }
}

class _ChooseRemindersBottomSheetState extends State<ChooseRemindersBottomSheet> with TickerProviderStateMixin {
  final descriptionTextController = TextEditingController();

  void _showCustomStageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return CustomJobStageBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewSessionTypePageState>(
        converter: (Store<AppState> store) =>
            NewSessionTypePageState.fromStore(store),
        builder: (BuildContext context, NewSessionTypePageState pageState) =>
            Container(
              height: MediaQuery.of(context).size.height-64,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16.0)),
                      color: Color(ColorConstants.getPrimaryWhite())),
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 16, left: 12, right: 12, top: 16),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Select Your Reminder',
                              ),
                            ),
                            Container(
                              height: 61,
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                tooltip: 'Add',
                                color: Color(ColorConstants.getBlueDark()),
                                onPressed: () {
                                  UserOptionsUtil.showNewReminderDialog(context, null);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      ReminderSelectionWidget(),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      alignment: Alignment.center,
                      height: 48,
                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'DONE',
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ],
              )
            ),
      );
}
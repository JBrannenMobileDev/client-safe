import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../models/ReminderDandyLight.dart';
import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_pricing_profile_page/DandyLightTextFieldOld.dart';
import 'NewReminderPageState.dart';

class ReminderDescriptionWidget extends StatefulWidget{
  final ReminderDandyLight? reminder;

  ReminderDescriptionWidget(this.reminder);

  @override
  _ReminderDescriptionWidgetState createState() {
    return _ReminderDescriptionWidgetState(reminder);
  }
}

class _ReminderDescriptionWidgetState extends State<ReminderDescriptionWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final ReminderDandyLight? reminder;
  final descriptionTextController = TextEditingController();

  _ReminderDescriptionWidgetState(this.reminder);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewReminderPageState>(
      onInit: (store) {
        descriptionTextController.text = store.state.newReminderPageState!.reminderDescription!;
      },
      converter: (store) => NewReminderPageState.fromStore(store),
      builder: (BuildContext context, NewReminderPageState pageState) =>
        Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child:
                Container(
                  color: Color(ColorConstants.white),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'What would you like to say in this reminder?',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      DandyLightTextFieldOld(
                        controller: descriptionTextController,
                        hintText: 'Reminder',
                        inputType: TextInputType.text,
                        focusNode: null,
                        onFocusAction: null,
                        height: 136.0,
                        onTextInputChanged: pageState.onReminderDescriptionChanged,
                        keyboardAction: TextInputAction.done,
                        capitalization: TextCapitalization.words,
                      ),
                    ],
                  ),
            ),
          ),
        ),
    );
  }
}
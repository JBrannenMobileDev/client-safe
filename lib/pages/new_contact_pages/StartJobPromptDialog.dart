import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class StartJobPromptDialog extends StatefulWidget {
  @override
  _StartJobPromptDialogState createState() {
    return _StartJobPromptDialogState();
  }
}

class _StartJobPromptDialogState extends State<StartJobPromptDialog>
    with AutomaticKeepAliveClientMixin {
  final jobTitleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 250.0,
              padding: EdgeInsets.only(left: 32.0, right: 32.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "Would you like to start a job for " + pageState.newContactFirstName + ' ' + pageState.newContactLastName + ' now ?',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          pageState.onStartNewJobSelected();
                          pageState.onCancelPressed();//just clears the pageState for cleanup.
                          Navigator.of(context).pop();
                          UserOptionsUtil.showNewJobDialog(context);
                          EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "Start job Prompt"});
                        },
                        child: Container(
                          height: 96.0,
                          width: 96.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getBlueDark())
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.EXTRA_LARGE_TEXT,
                            text: 'YES',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 96.0,
                          width: 96.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.EXTRA_LARGE_TEXT,
                            text: 'NO',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

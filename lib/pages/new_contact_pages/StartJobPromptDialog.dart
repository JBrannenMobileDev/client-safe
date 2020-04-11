import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPage.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
                    child: Text(
                      "Would you like to start a job for " + pageState.newContactFirstName + ' ' + pageState.newContactLastName + ' now ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
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
                        Navigator.of(context).pop();
                        UserOptionsUtil.showNewJobDialog(context);
                        },
                        child: Container(
                          height: 112.0,
                          width: 112.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPrimaryColor())
                          ),
                          child: Text(
                            'YES',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 48.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 112.0,
                          width: 112.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                          child: Text(
                            'NO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 48.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
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

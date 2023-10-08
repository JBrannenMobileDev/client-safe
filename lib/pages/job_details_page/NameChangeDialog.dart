import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class NameChangeDialog extends StatefulWidget {
  @override
  _NameChangeDialogState createState() {
    return _NameChangeDialogState();
  }
}

class _NameChangeDialogState extends State<NameChangeDialog>
    with AutomaticKeepAliveClientMixin {
  final jobTitleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, JobDetailsPageState>(
      onInit: (store) {
        jobTitleTextController.text = store.state.jobDetailsPageState.job.jobTitle;
      },
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
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
                        text: "Enter a simple and descriptive name for this job.",
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    NewJobTextField(
                      controller: jobTitleTextController,
                      hintText: "Job name",
                      inputType: TextInputType.text,
                      height: 64.0,
                      onTextInputChanged: pageState.onJobTitleTextChanged,
                      keyboardAction: TextInputAction.done,
                      capitalization: TextCapitalization.words,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Cancel',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            pageState.onNameChangeSaved();
                            VibrateUtil.vibrateHeavy();
                            Navigator.of(context).pop();
                          },
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Save',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class JobNameForm extends StatefulWidget {
  @override
  _JobNameFormState createState() {
    return _JobNameFormState();
  }
}

class _JobNameFormState extends State<JobNameForm>
    with AutomaticKeepAliveClientMixin {
  final jobTitleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        jobTitleTextController.text = store.state.newJobPageState.jobTitle;
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Enter a simple and descriptive name for this job.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
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
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

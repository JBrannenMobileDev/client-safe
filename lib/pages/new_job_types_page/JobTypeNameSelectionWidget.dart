import 'package:dandylight/models/JobType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_pricing_profile_page/DandyLightTextField.dart';
import 'NewJobTypePageState.dart';

class JobTypeNameSelectionWidget extends StatefulWidget{
  final JobType? jobType;

  JobTypeNameSelectionWidget(this.jobType);

  @override
  _JobTypeNameSelectionWidgetState createState() {
    return _JobTypeNameSelectionWidgetState(jobType);
  }
}

class _JobTypeNameSelectionWidgetState extends State<JobTypeNameSelectionWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final JobType? jobType;
  final descriptionTextController = TextEditingController();

  _JobTypeNameSelectionWidgetState(this.jobType);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobTypePageState>(
      onInit: (store) {
        descriptionTextController.text = store.state.newJobTypePageState!.title!;
      },
      converter: (store) => NewJobTypePageState.fromStore(store),
      builder: (BuildContext context, NewJobTypePageState pageState) =>
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
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'What do you want to name this Job Type?',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      DandyLightTextField(
                        controller: descriptionTextController,
                        hintText: 'Job Type Name',
                        inputType: TextInputType.text,
                        focusNode: null,
                        onFocusAction: null,
                        height: 66.0,
                        onTextInputChanged: pageState.onTitleChanged!,
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
import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/common_widgets/ClientSafeButton.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobClientListWidget.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobStagesListWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class JobStageSelectionForm extends StatefulWidget {
  @override
  _JobStageSelectionFormState createState() {
    return _JobStageSelectionFormState();
  }
}

class _JobStageSelectionFormState extends State<JobStageSelectionForm>  with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> jobStageIcons = ImageUtil.jobStageIcons;

    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 26.0, right: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6.0, bottom: 16.0),
                  child: Text(
                    'Please select completed job stages.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 450.0,
                  ),
                  child: ListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: jobStageIcons.length,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, NewJobPageState>(
    converter: (store) => NewJobPageState.fromStore(store),
    builder: (BuildContext context, NewJobPageState pageState) =>
        NewJobStagesListWidget(index),
  );
}

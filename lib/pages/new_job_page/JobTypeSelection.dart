import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class JobTypeSelection extends StatefulWidget {
  @override
  _JobTypeSelection createState() {
    return _JobTypeSelection();
  }
}

class _JobTypeSelection extends State<JobTypeSelection>
    with AutomaticKeepAliveClientMixin {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 26.0, right: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Select a job type',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                pageState.jobTypes.length > 0 ? Container(
                  height: 411.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: pageState.jobTypes.length,
                    itemBuilder: _buildItem,
                  ),
                ) : Container(
                  margin: EdgeInsets.only(top: 64.0),
                  padding: EdgeInsets.only(left: 32.0, right: 32.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'You have not saved any job types. To create a new job type please select the plus icon.\n\n(Example: Wedding, Engagement, Family, etc...)',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
      TextButton(
            style: Styles.getButtonStyle(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
              ),
              color: pageState.selectedJobType != null &&
                  pageState.selectedJobType.documentId == pageState.jobTypes.elementAt(index).documentId ? Color(
                  ColorConstants.getPrimaryBackgroundGrey()) : Colors.transparent,
            ),
            onPressed: () {
              pageState.onJobTypeSelected(
                  pageState.jobTypes.elementAt(index));
            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 4.0, right: 16.0),
                  height: 32.0,
                  width: 32.0,
                  child: Image.asset('assets/images/icons/briefcase_icon_peach_dark.png', color: Color(ColorConstants.getBlueDark())),
                ),
                Expanded(
                  child: Container(
                    height: 64.0,
                    margin: EdgeInsets.only(right: 32.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: pageState.jobTypes.elementAt(index).title,
                            textAlign: TextAlign.start,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ],
                      ),
                    ),
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

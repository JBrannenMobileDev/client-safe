import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Select a job type',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 400.0,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: pageState.jobTypes.length,
                    itemBuilder: _buildItem,
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
                borderRadius: new BorderRadius.circular(32.0),
              ),
              color: pageState.selectedJobType != null &&
                  pageState.selectedJobType == pageState.jobTypes.elementAt(index) ? Color(
                  ColorConstants.getBlueDark()) : Colors.transparent,
            ),
            onPressed: () {
              pageState.onJobTypeSelected(
                  pageState.jobTypes.elementAt(index));
            },
            child: Row(
              children: <Widget>[
                pageState.selectedJobType != null &&
                    pageState.selectedJobType == pageState.jobTypes.elementAt(index) ? Container(
                  margin: EdgeInsets.only(right: 16.0),
                  height: 28.0,
                  width: 28.0,
                  child: Image.asset('assets/images/icons/briefcase_icon_white.png'),
                ) : Container(
                  margin: EdgeInsets.only(right: 16.0),
                  height: 28.0,
                  width: 28.0,
                  child: Image.asset('assets/images/icons/briefcase_icon_peach_dark.png'),
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
                          Text(
                            pageState.jobTypes.elementAt(index),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: pageState.selectedJobType != null &&
                                  pageState.selectedJobType == pageState.jobTypes.elementAt(index) ? Color(
                                  ColorConstants.getPrimaryWhite()) : Color(
                                  ColorConstants.getPeachDark()),
                            ),
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

  int getIconPosition(NewJobPageState pageState, List<String> jobTypeIcons) {
    return jobTypeIcons.indexOf(pageState.selectedJobType);
  }
}

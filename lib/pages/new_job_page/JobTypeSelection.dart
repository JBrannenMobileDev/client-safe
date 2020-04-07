import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
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
                    itemCount: 16,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    List<String> jobTypeIcons = ImageUtil.jobIcons;
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(32.0),
            ),
            color: pageState.jobTypeIcon != null &&
                getIconPosition(pageState, jobTypeIcons) == index ? Color(
                ColorConstants.getBlueDark()) : Colors.transparent,
            onPressed: () {
              pageState.onJobTypeSelected(
                  jobTypeIcons.elementAt(index));
            },
            child: Row(
              children: <Widget>[
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
                            ImageUtil.getJobTypeText(jobTypeIcons.elementAt(
                                index)),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: pageState.jobTypeIcon != null &&
                                  getIconPosition(pageState, jobTypeIcons) ==
                                      index ? Color(
                                  ColorConstants.getPrimaryWhite()) : Color(
                                  ColorConstants.getPrimaryBlack()),
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
    return jobTypeIcons.indexOf(pageState.jobTypeIcon);
  }
}

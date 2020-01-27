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
    List<String> jobTypeIcons = ImageUtil.jobIcons;
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
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 16,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      pageState.onJobTypeSelected(jobTypeIcons.elementAt(index));
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(jobTypeIcons.elementAt(index)),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: pageState.jobTypeIcon != null && getIconPosition(pageState, jobTypeIcons) != index ? new Container(
                            decoration: new BoxDecoration(
                                color: Colors.white.withOpacity(0.5)),
                          ) : SizedBox(),
                        ),
                        Text(
                          ImageUtil.getJobTypeText(jobTypeIcons.elementAt(index)),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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

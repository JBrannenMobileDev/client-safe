import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class JobTypeChangeDialog extends StatefulWidget {
  @override
  _JobTypeChangeDialogState createState() {
    return _JobTypeChangeDialogState();
  }
}

class _JobTypeChangeDialogState extends State<JobTypeChangeDialog>
    with AutomaticKeepAliveClientMixin {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            pageState.onJobTypeSaveSelected();
                            VibrateUtil.vibrateHeavy();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    List<String> jobTypeIcons = ImageUtil.jobIcons;
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          TextButton(
            style: Styles.getButtonStyle(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(32.0),
              ),
              color: pageState.jobTypeIcon != null &&
                  getIconPosition(pageState, jobTypeIcons) == index ? Color(
                  ColorConstants.getBlueDark()) : Colors.transparent,
            ),
            onPressed: () {
              pageState.onJobTypeSelected(
                  jobTypeIcons.elementAt(index));
            },
            child: Row(
              children: <Widget>[
                pageState.jobTypeIcon != null && getIconPosition(pageState, jobTypeIcons) == index ? Container(
                  margin: EdgeInsets.only(right: 16.0),
                  height: 28.0,
                  width: 28.0,
                  child: Image.asset('assets/images/icons/briefcase_icon_white.png'),
                ) : SizedBox(),
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
                              color: pageState.jobTypeIcon != null && getIconPosition(pageState, jobTypeIcons) == index ? Color(
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

  int getIconPosition(JobDetailsPageState pageState, List<String> jobTypeIcons) {
    return jobTypeIcons.indexOf(pageState.jobTypeIcon);
  }
}

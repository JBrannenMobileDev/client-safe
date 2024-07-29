import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/TextFormatterUtil.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../widgets/TextDandyLight.dart';

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
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
            child: Container(
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 32.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Select a job type',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          UserOptionsUtil.showNewJobTypePage(context, null);
                        },
                        child: Container(
                          height: 28.0,
                          width: 28.0,
                          child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getBlueDark()),),
                        ),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 200.0,
                      maxHeight: 550.0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: pageState.sessionTypes!.length,
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
                            pageState.onSessionTypeSaveSelected!();
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
                  ),
                ],
              ),
            ),
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: TextButton(
              style: Styles.getButtonStyle(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                color: pageState.sessionType!.documentId == pageState.sessionTypes!.elementAt(index).documentId ? Color(
                    ColorConstants.getPrimaryGreyDark()).withOpacity(0.5) : Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
              ),
              onPressed: () {
                pageState.onSessionTypeSelected!(
                    pageState.sessionTypes!.elementAt(index)
                );
              },
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 16.0),
                    height: 28.0,
                    width: 28.0,
                    child: Image.asset('assets/images/icons/briefcase_icon_peach_dark.png', color: Color(ColorConstants.getPrimaryBlack())),
                  ),
                  Expanded(
                    child: Container(
                      height: 54.0,
                      margin: EdgeInsets.only(right: 32.0),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: pageState.sessionTypes!.elementAt(index).title,
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.EXTRA_SMALL_TEXT,
                              text: 'Price: ${TextFormatterUtil.formatDecimalDigitsCurrency(pageState.sessionTypes!.elementAt(index).totalCost, 0)}     ${(pageState.sessionTypes!.elementAt(index).deposit > 0) ? 'Deposit: ${TextFormatterUtil.formatDecimalDigitsCurrency(pageState.sessionTypes!.elementAt(index).deposit, 0)}' : ''}',
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
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class AddOnCostChangeDialog extends StatefulWidget {
  @override
  _AddOnCostChangeDialogState createState() {
    return _AddOnCostChangeDialogState();
  }
}

class _AddOnCostChangeDialogState extends State<AddOnCostChangeDialog>
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
              height: 432.0,
              padding: EdgeInsets.only(left: 32.0, right: 32.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),

              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(top: 146.0, right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        pageState.onClearUnsavedDeposit();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 42.0,
                        height: 42.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: IconButton(
                          icon: Icon(
                              Icons.clear,
                              size: 42.0,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                          tooltip: 'Add',
                          onPressed: null,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: "Select the Add-on cost amount",
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "This amount will be added to the current price of this job.",
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                          text: "\$" + pageState.unsavedAddOnCostAmount.toString(),
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: TextButton(
                              style: Styles.getButtonStyle(
                                color: Color(ColorConstants.getPrimaryColor()),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(48.0),
                                ),
                              ),
                              onPressed: () {
                                pageState.onAddToDeposit(1);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 100.0,
                                height: 64.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    TextDandyLight(
                                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                                      text: "+",
                                      textAlign: TextAlign.start,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                                      text: "\$1",
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextButton(
                              style: Styles.getButtonStyle(
                                color: Color(ColorConstants.getPrimaryColor()),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(48.0),
                                ),
                              ),
                              onPressed: () {
                                pageState.onAddToDeposit(5);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 100.0,
                                height: 64.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextDandyLight(
                                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                                      text: "+",
                                      textAlign: TextAlign.start,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                                      text: "\$5",
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: TextButton(
                                style: Styles.getButtonStyle(
                                  color: Color(ColorConstants.getPrimaryColor()),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(48.0),
                                  ),
                                ),
                                onPressed: () {
                                  pageState.onAddToDeposit(25);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 100.0,
                                  height: 64.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                                        text: "+",
                                        textAlign: TextAlign.start,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                                        text: "\$25",
                                        textAlign: TextAlign.center,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextButton(
                                style: Styles.getButtonStyle(
                                  color: Color(ColorConstants.getPrimaryColor()),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(48.0),
                                  ),
                                ),
                                onPressed: () {
                                  pageState.onAddToDeposit(100);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 100.0,
                                  height: 64.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                                        text: "+",
                                        textAlign: TextAlign.start,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                                        text: "\$100",
                                        textAlign: TextAlign.center,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Cancel',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                pageState.onSaveAddOnCost();
                                VibrateUtil.vibrateHeavy();
                                Navigator.of(context).pop();
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Save',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ],
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

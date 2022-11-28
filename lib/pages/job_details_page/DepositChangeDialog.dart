import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
                    padding: EdgeInsets.only(top: 134.0, right: 16.0),
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
                        child: Text(
                          "Select the Add-on cost amount",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          "This amount will be added to the current price of this job.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          "\$" + pageState.unsavedAddOnCostAmount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 52.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
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
                                width: 78.0,
                                height: 64.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "+",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 32.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w200,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                    ),
                                    Text(
                                      "\$1",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 32.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w600,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
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
                                width: 78.0,
                                height: 64.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "+",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 32.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w200,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                    ),
                                    Text(
                                      "\$5",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 32.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w600,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
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
                                  width: 78.0,
                                  height: 64.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "+",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 32.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w200,
                                          color: Color(ColorConstants.getPrimaryWhite()),
                                        ),
                                      ),
                                      Text(
                                        "\$25",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 32.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w600,
                                          color: Color(ColorConstants.getPrimaryWhite()),
                                        ),
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
                                  width: 78.0,
                                  height: 64.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "+",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 32.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w200,
                                          color: Color(ColorConstants.getPrimaryWhite()),
                                        ),
                                      ),
                                      Text(
                                        "\$100",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 32.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w600,
                                          color: Color(ColorConstants.getPrimaryWhite()),
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
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                pageState.onSaveAddOnCost();
                                VibrateUtil.vibrateHeavy();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.0,
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

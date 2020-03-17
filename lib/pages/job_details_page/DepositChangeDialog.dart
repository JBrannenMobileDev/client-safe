import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DepositChangeDialog extends StatefulWidget {
  @override
  _DepositChangeDialogState createState() {
    return _DepositChangeDialogState();
  }
}

class _DepositChangeDialogState extends State<DepositChangeDialog>
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
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 350.0,
              padding: EdgeInsets.only(left: 32.0, right: 32.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),

              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(top: 62.0, right: 16.0),
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
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          "Select a new deposit amount.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          "\$" + pageState.unsavedDepositAmount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48.0,
                            fontFamily: 'Raleway',
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
                            child: FlatButton(
                              onPressed: () {
                                pageState.onAddToDeposit(1);
                              },
                              color: Color(ColorConstants.getPrimaryColor()),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(48.0),
                              ),
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
                                        fontSize: 48.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w200,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                    ),
                                    Text(
                                      "\$1",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontFamily: 'Raleway',
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
                            child: FlatButton(
                              onPressed: () {
                                pageState.onAddToDeposit(5);
                              },
                              color: Color(ColorConstants.getPrimaryColor()),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(48.0),
                              ),
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
                                        fontSize: 48.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w200,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                    ),
                                    Text(
                                      "\$5",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontFamily: 'Raleway',
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
                              child: FlatButton(
                                onPressed: () {
                                  pageState.onAddToDeposit(25);
                                },
                                color: Color(ColorConstants.getPrimaryColor()),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(48.0),
                                ),
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
                                          fontSize: 48.0,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.w200,
                                          color: Color(ColorConstants.getPrimaryWhite()),
                                        ),
                                      ),
                                      Text(
                                        "\$25",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontFamily: 'Raleway',
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
                              child: FlatButton(
                                onPressed: () {
                                  pageState.onAddToDeposit(100);
                                },
                                color: Color(ColorConstants.getPrimaryColor()),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(48.0),
                                ),
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
                                          fontSize: 48.0,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.w200,
                                          color: Color(ColorConstants.getPrimaryWhite()),
                                        ),
                                      ),
                                      Text(
                                        "\$100",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontFamily: 'Raleway',
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
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                pageState.onSaveDepositChange();
                                VibrateUtil.vibrateHeavy();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}

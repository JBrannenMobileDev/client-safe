import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TipChangePage extends StatefulWidget {
  @override
  _TipChangePageState createState() {
    return _TipChangePageState();
  }
}

class _TipChangePageState extends State<TipChangePage>
    with AutomaticKeepAliveClientMixin {
  final jobTitleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
      onInit: (store) {
        jobTitleTextController.text = store.state.incomeAndExpensesPageState.selectedJob.jobTitle;
      },
      converter: (store) => IncomeAndExpensesPageState.fromStore(store),
      builder: (BuildContext context, IncomeAndExpensesPageState pageState) =>
          Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          "Select the tip amount received.",
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
                          "\$" + pageState.unsavedTipAmount.toString(),
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
                            child: FlatButton(
                              onPressed: () {
                                pageState.onAddToTip(1);
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
                            child: FlatButton(
                              onPressed: () {
                                pageState.onAddToTip(5);
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
                              child: FlatButton(
                                onPressed: () {
                                  pageState.onAddToTip(25);
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
                              child: FlatButton(
                                onPressed: () {
                                  pageState.onAddToTip(100);
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
                    ],
                  ),
                ],
              ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

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
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Select the tip amount received.",
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                          text: "\$" + pageState.unsavedTipAmount.toString(),
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: TextButton(
                              style: Styles.getButtonStyle(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(48.0),
                                ),
                                color: Color(ColorConstants.getPrimaryColor()),
                              ),
                              onPressed: () {
                                pageState.onAddToTip(1);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 78.0,
                                height: 64.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                pageState.onAddToTip(5);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 78.0,
                                height: 64.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  pageState.onAddToTip(25);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 78.0,
                                  height: 64.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  pageState.onAddToTip(100);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 78.0,
                                  height: 64.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    ],
                  ),
                ],
              ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

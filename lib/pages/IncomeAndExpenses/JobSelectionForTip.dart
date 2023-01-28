import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/AddTipJobListItem.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class JobSelectionForTip extends StatefulWidget {
  @override
  _JobSelectionForTipState createState() {
    return _JobSelectionForTipState();
  }
}

class _JobSelectionForTipState extends State<JobSelectionForTip> with AutomaticKeepAliveClientMixin {
  bool searchHasFocus = false;
  final searchTextController = TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
      onInit: (store) {
        searchTextController.text = store.state.incomeAndExpensesPageState.jobSearchText;
      },
      converter: (store) => IncomeAndExpensesPageState.fromStore(store),
      builder: (BuildContext context, IncomeAndExpensesPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: "What job is the tip for?",
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.primary_black),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 264.0),
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'Edit',
                        color: Color(ColorConstants.getPrimaryColor()),
                        onPressed: (){},
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        alignment: Alignment.center,
                        width: 225.0,
                        height: 45.0,
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          maxLines: 1,
                          autofocus: false,
                          controller: searchTextController,
                          cursorColor: Color(ColorConstants.getPrimaryColor()),
                          onChanged: (text) {
                            pageState.onJobSearchTextChanged(text);
                          },
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: "Job name",
                            hintStyle: new TextStyle(
                                fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                                fontFamily: TextDandyLight.getFontFamily(),
                                fontWeight: TextDandyLight.getFontWeight(),
                                color: Color(ColorConstants.primary_black)),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(10.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(ColorConstants.getPrimaryColor()),
                                width: 1.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(ColorConstants.getPrimaryColor()),
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: new TextStyle(
                              fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                              fontFamily: TextDandyLight.getFontFamily(),
                              fontWeight: TextDandyLight.getFontWeight(),
                              color: Color(ColorConstants.primary_black)),
                        )),
                  ],
                ),
                pageState.filteredJobs.length > 0 ? ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 450.0,
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      ListView.builder(
                        reverse: false,
                        padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                        shrinkWrap: true,
                        controller: _controller,
                        physics: ClampingScrollPhysics(),
                        itemCount: pageState.filteredJobs.length,
                        itemBuilder: _buildItem,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 32.0,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.0),
                                ],
                                begin: const FractionalOffset(0.0, 1.0),
                                end: const FractionalOffset(0.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: pageState.allJobs.length > 0
                            ? "There are no matching jobs for the name entered."
                            : "You have not started any jobs yet.",
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    ClientSafeButton(
                      height: 50.0,
                      width: 200.0,
                      text: "Start a new job",
                      marginLeft: 0.0,
                      marginRight: 0.0,
                      marginBottom: 0.0,
                      marginTop: 32.0,
                      onPressed: startNewJobSelected,
                      urlText: "",
                      color: ColorConstants.getPrimaryColor()
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void startNewJobSelected() {
    Navigator.of(context).pop();
    UserOptionsUtil.showNewJobDialog(context);
    EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "New Tip Page"});
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, NewJobPageState>(
    converter: (store) => NewJobPageState.fromStore(store),
    builder: (BuildContext context, NewJobPageState pageState) =>
        AddTipJobListItem(index),
  );
}

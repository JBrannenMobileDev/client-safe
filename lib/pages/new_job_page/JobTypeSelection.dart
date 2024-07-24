import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

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
            margin: EdgeInsets.only(left: 0.0, right: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                pageState.sessionTypes!.length > 0 ? Container(
                  height: (MediaQuery.of(context).size.height*0.7) - 61,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: pageState.sessionTypes!.length,
                    itemBuilder: _buildItem,
                  ),
                ) : Container(
                  margin: EdgeInsets.only(top: 64.0),
                  padding: EdgeInsets.only(left: 32.0, right: 32.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'To create a new session type please select the plus icon.',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
      TextButton(
            style: Styles.getButtonStyle(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
              ),
              color: pageState.selectedSessionType != null &&
                  pageState.selectedSessionType!.documentId == pageState.sessionTypes!.elementAt(index).documentId ? Color(
                  ColorConstants.getPrimaryGreyDark()).withOpacity(0.5) : Colors.transparent,
            ),
            onPressed: () {
              pageState.onSessionTypeSelected!(pageState.sessionTypes!.elementAt(index));
              Navigator.of(context).pop();
            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 4.0, right: 16.0),
                  height: 32.0,
                  width: 32.0,
                  child: Image.asset('assets/images/icons/briefcase_icon_peach_dark.png', color: Color(ColorConstants.getBlueDark())),
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
}

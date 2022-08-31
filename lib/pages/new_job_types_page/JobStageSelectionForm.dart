import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'NewJobTypePageState.dart';
import 'NewJobTypeStagesListWidget.dart';

class JobStageSelectionForm extends StatefulWidget {
  @override
  _JobStageSelectionFormState createState() {
    return _JobStageSelectionFormState();
  }
}

class _JobStageSelectionFormState extends State<JobStageSelectionForm>  with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(ColorConstants.getPrimaryBlack());
      }
      return Color(ColorConstants.getPeachDark());
    }

    return StoreConnector<AppState, NewJobTypePageState>(
      converter: (store) => NewJobTypePageState.fromStore(store),
      builder: (BuildContext context, NewJobTypePageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6.0, bottom: 8.0, left: 16.0, right: 16.0),
                  child: Text(
                    'Please select stages for this job type that you would like to track.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Text(
                        'Check All',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 16.0),
                      child: Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: pageState.checkAllTypes,
                        onChanged: (bool isChecked) {
                          pageState.checkAllTypesChecked(isChecked);
                        },
                      ),
                    ),
                  ],
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 450.0,
                  ),
                  child: ReorderableListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 64.0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.allJobStages.length,
                    itemBuilder: _buildItem,
                    onReorder: (int oldIndex, int newIndex) {

                    },
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

Widget _buildItem(BuildContext context, int index) {
  return  Padding(
      key: Key(index.toString()),
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
      child: StoreConnector<AppState, NewJobTypePageState>(
        converter: (store) => NewJobTypePageState.fromStore(store),
        builder: (BuildContext context, NewJobTypePageState pageState) =>
            NewJobTypeStagesListWidget(index),
      ));
}

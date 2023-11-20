import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/JobStage.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewJobTypePageState.dart';
import 'NewJobTypeStagesListWidget.dart';

class JobStageSelectionForm extends StatefulWidget {
  @override
  _JobStageSelectionFormState createState() {
    return _JobStageSelectionFormState();
  }
}

class _JobStageSelectionFormState extends State<JobStageSelectionForm>  with AutomaticKeepAliveClientMixin{
  List<JobStage> stages = [];

  void reorderData(int oldIndex, int newIndex){
    setState(() {
      if(newIndex > oldIndex){
        newIndex -= 1;
      }
      final items = stages.removeAt(oldIndex);
      stages.insert(newIndex, items);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StoreConnector<AppState, NewJobTypePageState>(
      onInit: (store) {
        stages = store.state.newJobTypePageState.selectedJobStages;
      },
      onDidChange: (previous, current) {
        setState(() {
          stages = current.selectedJobStages;
        });
      },
      converter: (store) => NewJobTypePageState.fromStore(store),
      builder: (BuildContext context, NewJobTypePageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6.0, bottom: 8.0, left: 16.0, right: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Please select stages for this job type that you would like to track.\n\nDrag and swipe items to customize your workflow.',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 440.0,
                  ),
                  child: ReorderableListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 64.0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.selectedJobStages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(stages.elementAt(index).id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Color(ColorConstants.getPeachDark()),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.0),
                        ),
                        onDismissed: (direction) {
                          pageState.onJobStageDeleted(index);
                          setState(() {
                            stages.removeAt(index);
                          });
                        },
                        child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                            child: StoreConnector<AppState, NewJobTypePageState>(
                              converter: (store) => NewJobTypePageState.fromStore(store),
                              builder: (BuildContext context, NewJobTypePageState pageState) =>
                                  NewJobTypeStagesListWidget(index),
                            )
                        ),
                      );
                    },
                    onReorder: reorderData,
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

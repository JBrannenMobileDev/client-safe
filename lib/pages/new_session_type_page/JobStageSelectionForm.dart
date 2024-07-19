import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/JobStage.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewSessionTypePageState.dart';
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

    return StoreConnector<AppState, NewSessionTypePageState>(
      onInit: (store) {
        stages = store.state.newSessionTypePageState!.selectedJobStages!;
      },
      onDidChange: (previous, current) {
        setState(() {
          stages = current.selectedJobStages!;
        });
      },
      converter: (store) => NewSessionTypePageState.fromStore(store),
      builder: (BuildContext context, NewSessionTypePageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 8.0, left: 16.0, right: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Please reorder, add, or remove stages to fit your workflow.',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 84,
                  padding: EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5)
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'TIPS\n- Long press to reorder\n- Swipe left to remove stage',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 589.0,
                  ),
                  child: ReorderableListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 64.0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.selectedJobStages!.length,
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
                          setState(() {
                            // stages.removeAt(index);
                            pageState.onJobStageDeleted!(index);
                          });
                        },
                        child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                            child: StoreConnector<AppState, NewSessionTypePageState>(
                              converter: (store) => NewSessionTypePageState.fromStore(store),
                              builder: (BuildContext context, NewSessionTypePageState pageState) =>
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

import 'package:dandylight/pages/poses_page/widgets/PosesMyPoseGroupsListItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';
import '../PosesPageState.dart';


class SaveToMyPosesBottomSheet extends StatefulWidget {
  final int libraryPoseIndex;

  SaveToMyPosesBottomSheet(this.libraryPoseIndex);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState(libraryPoseIndex);
  }
}

class _BottomSheetPageState extends State<SaveToMyPosesBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final int libraryPoseIndex;

  _BottomSheetPageState(this.libraryPoseIndex);

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          GestureDetector(
            onTap: () {
              pageState.onImageSaveSelected(pageState.searchResultsImages.elementAt(libraryPoseIndex), pageState.poseGroups.elementAt(index));
              showSuccessAnimation();
              EventSender().sendEvent(eventName: EventNames.BT_SAVE_LIBRARY_SEARCH_POSE);
            },
            child: PosesMyPoseGroupsListItem(index),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, PosesPageState>(
    converter: (Store<AppState> store) => PosesPageState.fromStore(store),
    builder: (BuildContext context, PosesPageState pageState) =>
         Container(
           height: 350,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: EdgeInsets.only(left: 16.0, right: 16.0),
             child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(top: 24),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: 'Save to My Poses',
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.primary_black),
                       ),
                     ),
                     SingleChildScrollView(
                       child: Container(
                       height: 302,
                       child: GridView.builder(
                           padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 300.0),
                           gridDelegate:
                           const SliverGridDelegateWithMaxCrossAxisExtent(
                               maxCrossAxisExtent: 150,
                               childAspectRatio: 3 / 3,
                               crossAxisSpacing: 0,
                               mainAxisSpacing: 0
                           ),
                           itemCount: pageState.poseGroups.length,
                           controller: _controller,
                           physics: AlwaysScrollableScrollPhysics(),
                           key: _listKey,
                           shrinkWrap: true,
                           reverse: false,
                           itemBuilder: _buildItem
                       ),
                       ),
                     ),
                   ],
           ),
         ),
    );

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
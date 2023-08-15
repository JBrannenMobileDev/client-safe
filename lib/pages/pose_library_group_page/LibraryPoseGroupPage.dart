import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/LibraryPoseListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

import '../../models/Job.dart';
import '../../models/PoseLibraryGroup.dart';
import '../../utils/DandyToastUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import '../poses_page/GoToJobPosesBottomSheet.dart';
import 'LibraryPoseGroupActions.dart';
import 'LibrarySingleImageViewPager.dart';

class LibraryPoseGroupPage extends StatefulWidget {
  final PoseLibraryGroup poseGroup;
  final Job job;
  final bool comingFromDetails;

  LibraryPoseGroupPage(this.poseGroup, this.job, this.comingFromDetails);

  @override
  State<StatefulWidget> createState() {
    return _LibraryPoseGroupPageState(poseGroup, job, comingFromDetails);
  }
}

class _LibraryPoseGroupPageState extends State<LibraryPoseGroupPage>
    with TickerProviderStateMixin {
  final PoseLibraryGroup poseGroup;
  final Job job;
  final bool comingFromDetails;

  _LibraryPoseGroupPageState(this.poseGroup, this.job, this.comingFromDetails);

  Widget _buildItem(BuildContext context, int index, ) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      converter: (store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          GestureDetector(
            onTap: () {
              if(job == null) {
                Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => LibrarySingleImageViewPager(
                      pageState.sortedPoses,
                      index,
                      pageState.poseGroup.groupName
                  )),
                );
              } else {
                pageState.onImageAddedToJobSelected(pageState.sortedPoses.elementAt(index), job);
                VibrateUtil.vibrateMedium();
                DandyToastUtil.showToastWithGravity('Pose Added!', Color(ColorConstants.getPeachDark()), ToastGravity.CENTER);
                EventSender().sendEvent(eventName: EventNames.BT_SAVE_LIBRARY_POSE_TO_JOB_FROM_JOB);
              }
            },
            child: LibraryPoseListWidget(index, job),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      onInit: (store) async {
        store.dispatch(ClearLibraryPoseGroupState(store.state.libraryPoseGroupPageState));
        store.dispatch(LoadLibraryPoseGroup(store.state.libraryPoseGroupPageState, poseGroup));
        store.dispatch(SortGroupImages(store.state.libraryPoseGroupPageState, poseGroup));
      },
      converter: (Store<AppState> store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          Scaffold(
          bottomSheet: job != null ? GoToJobPosesBottomSheet(job, comingFromDetails ? 2 : 2) : SizedBox(),
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Color(
                          ColorConstants.getPeachDark()), //change your color here
                    ),
                    backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                    centerTitle: true,
                    elevation: 4.0,
                    pinned: true,
                    snap: false,
                    floating: true,
                    forceElevated: false,
                    title: Container(
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: poseGroup.groupName,
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 64),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2 / 2.45,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16),
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return Container(
                          height: (MediaQuery.of(context).size.height),
                          child: _buildItem(context, index),
                        );
                      },
                        childCount: pageState.sortedPoses.length, // 1000 list items
                      ),
                    ),
                  ),
                ],
                cacheExtent: 3500,
              ),
            ],
          ),
      ),
    );
  }
}
import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/poses_page/GoToJobPosesBottomSheet.dart';
import 'package:dandylight/pages/poses_page/widgets/PoseGroupListWidget.dart';
import 'package:dandylight/pages/poses_page/widgets/PoseLibraryGroupListWidget.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../models/Job.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'PosesActions.dart';
import 'PosesPageState.dart';

class PosesPage extends StatefulWidget {
  static const String FILTER_TYPE_MY_POSES = "My Poses";
  static const String FILTER_TYPE_POSE_LIBRARY = "Pose Library";
  final Job job;

  PosesPage(this.job);

  @override
  State<StatefulWidget> createState() {
    return _PosesPageState(job);
  }
}

class _PosesPageState extends State<PosesPage> {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int selectedIndex = 0;
  Map<int, Widget> tabs;
  Job job;

  _PosesPageState(this.job);

  @override
  Widget build(BuildContext context) {
    tabs = <int, Widget>{
      0: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: PosesPage.FILTER_TYPE_MY_POSES,
        color: Color(selectedIndex == 0
            ? ColorConstants.getPrimaryBlack()
            : ColorConstants.getPeachDark()),
      ),
      1: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: PosesPage.FILTER_TYPE_POSE_LIBRARY,
        color: Color(selectedIndex == 1
            ? ColorConstants.getPrimaryBlack()
            : ColorConstants.getPeachDark()),
      ),
    };
    return StoreConnector<AppState, PosesPageState>(
      onInit: (store) async {
        store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
      },
      converter: (Store<AppState> store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          Scaffold(
            bottomSheet: job != null
                ? GoToJobPosesBottomSheet(job, 2)
                : SizedBox(),
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Color(
                        ColorConstants.getPeachDark()), //change your color here
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                  centerTitle: true,
                  title: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: job != null ? 'Select Poses' : "Poses",
                    color: Color(ColorConstants.getPeachDark()),
                  ),
                  actions: <Widget>[
                    selectedIndex == 0 && job == null ? GestureDetector(
                      onTap: () {
                        UserOptionsUtil.showNewPoseGroupDialog(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 26.0),
                        height: 24.0,
                        width: 24.0,
                        child: Image.asset('assets/images/icons/plus.png',
                          color: Color(ColorConstants.getPeachDark()),),
                      ),
                    ) : SizedBox(),
                    GestureDetector(
                      onTap: () {
                        NavigationUtil.onSearchPosesSelected(context, job);
                        EventSender().sendEvent(
                            eventName: EventNames.NAV_TO_POSE_LIBRARY_SEARCH);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 26.0),
                        height: 24.0,
                        width: 24.0,
                        child: Image.asset('assets/images/icons/search.png',
                          color: Color(ColorConstants.getPeachDark()),),
                      ),
                    ),
                  ],
                  elevation: 0.0,
                  pinned: false,
                  floating: false,
                  forceElevated: false,
                  expandedHeight: 100,
                  flexibleSpace: new FlexibleSpaceBar(
                    background: Column(
                      children: <Widget>[
                        SafeArea(
                          child: PreferredSize(
                            child: Container(
                              width: 300.0,
                              margin: EdgeInsets.only(top: 56.0),
                              child: CupertinoSlidingSegmentedControl<int>(
                                thumbColor: Color(
                                    ColorConstants.getPrimaryWhite()),
                                backgroundColor: Colors.transparent,
                                children: tabs,
                                onValueChanged: (int filterTypeIndex) {
                                  setState(() {
                                    selectedIndex = filterTypeIndex;
                                  });
                                  if (filterTypeIndex == 0) EventSender()
                                      .sendEvent(
                                      eventName: EventNames.NAV_TO_MY_POSES);
                                  if (filterTypeIndex == 1) EventSender()
                                      .sendEvent(eventName: EventNames
                                      .NAV_TO_POSE_LIBRARY);
                                },
                                groupValue: selectedIndex,
                              ),
                            ),
                            preferredSize: Size.fromHeight(44.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return selectedIndex == 0 ? PoseGroupListWidget(index, job) : PoseLibraryGroupListWidget(index, job);
                  },
                    childCount: selectedIndex == 0 ? pageState.poseGroups.length : pageState.libraryGroups.length, // 1000 list items
                  ),
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      selectedIndex == 0 && pageState.groupImages.length == 0 ? Padding(
                        padding: EdgeInsets.only(
                            left: 32.0, top: 48.0, right: 32.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Save your poses here. \nSelect the plus icon to create a new collection.",
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPeachDark()),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
  }

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/poses_page/GoToJobPosesBottomSheet.dart';
import 'package:dandylight/pages/poses_page/widgets/PoseGroupListWidget.dart';
import 'package:dandylight/pages/poses_page/widgets/PoseLibraryGroupListWidget.dart';
import 'package:dandylight/pages/poses_page/widgets/SubmittedPoseListWidget.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

import '../../models/Job.dart';
import '../../utils/DandyToastUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'PoseSearchSingleImageViewPager.dart';
import 'PosesActions.dart';
import 'PosesPageState.dart';

class PosesPage extends StatefulWidget {
  static const String FILTER_TYPE_MY_POSES = "Saved";
  static const String FILTER_TYPE_POSE_LIBRARY = "Library";
  static const String FILTER_TYPE_SUBMITTED_POSES = "Submitted";
  final Job job;
  final bool comingFromDetails;

  PosesPage(this.job, this.comingFromDetails);

  @override
  State<StatefulWidget> createState() {
    return _PosesPageState(job, comingFromDetails);
  }
}

class _PosesPageState extends State<PosesPage> {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int selectedIndex = 0;
  Map<int, Widget> tabs;
  Job job;
  bool comingFromDetails;

  _PosesPageState(this.job, this.comingFromDetails);

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
      2: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: PosesPage.FILTER_TYPE_SUBMITTED_POSES,
        color: Color(selectedIndex == 2
            ? ColorConstants.getPrimaryBlack()
            : ColorConstants.getPeachDark()),
      ),
    };
    return StoreConnector<AppState, PosesPageState>(
      onInit: (store) async {
        store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
        store.dispatch(LoadMoreSubmittedImagesAction(store.state.posesPageState));
      },
      converter: (Store<AppState> store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          Scaffold(
            bottomSheet: job != null
                ? GoToJobPosesBottomSheet(job, comingFromDetails ? 1 : 1)
                : SizedBox(),
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            floatingActionButton: job == null ? FloatingActionButton(
              onPressed: () {
                NavigationUtil.onUploadPoseSelected(context, pageState.profile);
              },
              backgroundColor: Color(ColorConstants.getPeachDark()),
              splashColor: Color(ColorConstants.getPeachDark()),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 2, bottom: 2),
                child: Image.asset('assets/images/icons/add_photo.png',
                  color: Color(ColorConstants.getPrimaryWhite()),
                  width: 42,
                ),
              ),
            ) : SizedBox(),
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
                    pageState.isAdmin ? GestureDetector(
                      onTap: () {
                        NavigationUtil.onReviewPosesSelected(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 26.0),
                        height: 24.0,
                        width: 24.0,
                        child: Image.asset('assets/images/icons/image_review.png',
                          color: Color(ColorConstants.getPeachDark()),),
                      ),
                    ) : SizedBox(),
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
                        NavigationUtil.onSearchPosesSelected(context, job, comingFromDetails);
                        EventSender().sendEvent(eventName: EventNames.NAV_TO_POSE_LIBRARY_SEARCH);
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
                                  if (filterTypeIndex == 2) EventSender()
                                      .sendEvent(eventName: EventNames
                                      .NAV_TO_SUBMITTED_POSES);
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
                selectedIndex != 2 ? SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return selectedIndex == 0 ? PoseGroupListWidget(index, job, comingFromDetails) : PoseLibraryGroupListWidget(index, job, comingFromDetails);
                  },
                    childCount: selectedIndex == 0 ? pageState.poseGroups.length : pageState.libraryGroups.length, // 1000 list items
                  ),
                ) : pageState.submittedPoses.length > 0 ? SliverPadding(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 64),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2.45,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,

                    ),
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return Container(
                        height: (MediaQuery.of(context).size.height),
                        child: _buildItem(context, index),
                      );
                    },
                      childCount: pageState.submittedPoses == null ? 0 : pageState.submittedPoses.length,
                    ),
                  ),
                ) : SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      selectedIndex == 2 ? Padding(
                        padding: EdgeInsets.only(
                            left: 32.0, top: 48.0, right: 32.0),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Your submitted poses will be listed here. \nSelect the camera icon to submit a new pose.",
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPeachDark()),
                        ),
                      ) : SizedBox(),
                    ],
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

  Widget _buildItem(BuildContext context, int index, ) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          GestureDetector(
            onTap: () {
              if(job == null) {
                Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => PoseSearchSingleImageViewPager(
                    pageState.submittedPoses,
                    index,
                    'Submitted',
                  )),
                );
              } else {
                pageState.onImageAddedToJobSelected(pageState.searchResultsImages.elementAt(index).pose, job);
                VibrateUtil.vibrateMedium();
                DandyToastUtil.showToastWithGravity('Pose Added!', Color(ColorConstants.getPeachDark()), ToastGravity.CENTER);
                EventSender().sendEvent(eventName: EventNames.BT_SAVE_SUBMITTED_POSE_TO_JOB_FROM_JOB);
              }

              if(job != null) {
                pageState.onImageAddedToJobSelected(pageState.submittedPoses.elementAt(index).pose, job);
                VibrateUtil.vibrateMedium();
                DandyToastUtil.showToastWithGravity('Pose Added!', Color(ColorConstants.getPeachDark()), ToastGravity.CENTER);
                EventSender().sendEvent(eventName: EventNames.BT_SAVE_SUBMITTED_POSE_TO_JOB_FROM_JOB);
              }
            },
            child: SubmittedPoseListWidget(index, job),
          ),
    );
  }

  }

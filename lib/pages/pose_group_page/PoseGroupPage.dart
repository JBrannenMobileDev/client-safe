import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/pages/pose_group_page/SingleImageViewPager.dart';
import 'package:dandylight/pages/pose_group_page/widgets/PoseListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/UserPermissionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

import '../../models/Job.dart';
import '../../models/PoseGroup.dart';
import '../../utils/DandyToastUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import '../poses_page/GoToJobPosesBottomSheet.dart';
import 'PoseGroupActions.dart';

class PoseGroupPage extends StatefulWidget {
  final PoseGroup poseGroup;
  final Job job;
  final bool comingFromDetails;

  PoseGroupPage(this.poseGroup, this.job, this.comingFromDetails);

  @override
  State<StatefulWidget> createState() {
    return _PoseGroupPageState(poseGroup, job, comingFromDetails);
  }
}

class _PoseGroupPageState extends State<PoseGroupPage>
    with TickerProviderStateMixin {
  final PoseGroup poseGroup;
  final Job job;
  final bool comingFromDetails;

  _PoseGroupPageState(this.poseGroup, this.job, this.comingFromDetails);

  Future getDeviceImage(PoseGroupPageState pageState) async {
    try{
      List<XFile> images = await ImagePicker().pickMultiImage();
      if(images.length != null && images.length > 0) {
        pageState.onNewPoseImagesSelected(images);
      }
    } catch(ex) {
      print(ex.toString());
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, PoseGroupPageState>(
      converter: (store) => PoseGroupPageState.fromStore(store),
      builder: (BuildContext context, PoseGroupPageState pageState) =>
          GestureDetector(
            onTap: () {
              if(job == null) {
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => SingleImageViewPager(
                    pageState.poseImages,
                    index,
                    pageState.onDeletePoseSelected,
                    pageState.poseGroup.groupName,
                )),
                );
              } else {
                pageState.onImageAddedToJobSelected(pageState.poseImages.elementAt(index).pose, job);
                VibrateUtil.vibrateMedium();
                DandyToastUtil.showToastWithGravity('Pose Added!', Color(ColorConstants.getPeachDark()), ToastGravity.CENTER);
                EventSender().sendEvent(eventName: EventNames.BT_SAVE_MY_POSE_TO_JOB_FROM_JOB);
              }
            },
            child: PoseListWidget(index, job),
          ),
    );
  }

  Future<void> _ackAlert(BuildContext context, PoseGroupPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos
            ? CupertinoAlertDialog(
                title: new Text('Are you sure?'),
                content:
                    new Text('This pose collection will be gone for good!'),
                actions: <Widget>[
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () {
                      pageState.onDeletePoseGroupSelected();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes'),
                  ),
                ],
              )
            : AlertDialog(
                title: new Text('Are you sure?'),
                content:
                    new Text('This pose collection will be gone for good!'),
                actions: <Widget>[
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () {
                      pageState.onDeletePoseGroupSelected();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes'),
                  ),
                ],
              );
      },
    );
  }

  AnimationController _controllerSlideUp;
  Tween<Offset> slideUpTween;
  bool isBottomSheetVisible = false;
  bool selectAllChecked = false;

  @override
  void initState() {
    super.initState();
    _controllerSlideUp = new AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
      vsync: this,
    );

    slideUpTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, -0.0),
    );
  }

  Animation<Offset> get slideUpAnimation => slideUpTween.animate(
        new CurvedAnimation(
          parent: _controllerSlideUp,
          curve: Curves.ease,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PoseGroupPageState>(
      onInit: (store) async {
        store.dispatch(ClearPoseGroupState(store.state.poseGroupPageState));
        store.dispatch(LoadPoseImagesFromStorage(store.state.poseGroupPageState, poseGroup));
      },
      converter: (Store<AppState> store) => PoseGroupPageState.fromStore(store),
      builder: (BuildContext context, PoseGroupPageState pageState) =>
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
                    actions: <Widget>[
                      job == null ? GestureDetector(
                        onTap: () {
                          getDeviceImage(pageState);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 22.0),
                          height: 28.0,
                          width: 28.0,
                          child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPeachDark()),),
                        ),
                      ) : SizedBox(),
                      job == null ? GestureDetector(
                        onTap: () {
                          _ackAlert(context, pageState);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 26.0),
                          height: 28.0,
                          width: 28.0,
                          child: Image.asset(
                            'assets/images/icons/trashcan.png',
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                        ),
                      ) : SizedBox(),
                    ],
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
                        childCount: pageState.poseGroup != null ? pageState.poseGroup.poses.length : 0, // 1000 list items
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        pageState.poseImages.length > 0 ? SizedBox() : poseGroup.poses.length == 0 && !pageState.isLoadingNewImages ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 48.0,
                                  top: 48.0,
                                  right: 48.0,
                                  bottom: 32.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: "You do not have any poses in this collection yet. Select the button below to add a pose.",
                                // \n\nYou can also share your saved locations with a client to help them decide what location they want.
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                getDeviceImage(pageState);
                              },
                              child: Container(
                                height: 64.0,
                                width: 64.0,
                                child: Image.asset(
                                  'assets/images/icons/add_photo.png',
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 32.0,
                              ),
                              child: TextButton(
                                style: Styles.getButtonStyle(
                                  color: Color(ColorConstants.getPeachDark()),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(32.0),
                                  ),
                                ),
                                onPressed: () {
                                  getDeviceImage(pageState);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: "Select Images",
                                    textAlign: TextAlign.center,
                                    color: Color(
                                        ColorConstants.getPrimaryWhite()),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
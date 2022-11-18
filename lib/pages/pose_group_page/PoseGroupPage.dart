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
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

import '../../models/PoseGroup.dart';
import 'PoseGroupActions.dart';

class PoseGroupPage extends StatefulWidget {
  final PoseGroup poseGroup;

  PoseGroupPage(this.poseGroup);

  @override
  State<StatefulWidget> createState() {
    return _PoseGroupPageState(poseGroup);
  }
}

class _PoseGroupPageState extends State<PoseGroupPage>
    with TickerProviderStateMixin {
  final PoseGroup poseGroup;
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  _PoseGroupPageState(this.poseGroup);

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
              if(isBottomSheetVisible){
                pageState.onImageChecked(pageState.poseImages.elementAt(index));
              } else {
                Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => SingleImageViewPager(
                      pageState.poseImages,
                      index,
                      pageState.onDeletePoseSelected,
                      pageState.poseGroup.groupName,
                  )),
                );
              }
            },
            child: PoseListWidget(index),
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

  Future<void> _ackAlertDeletePoses(BuildContext context, PoseGroupPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos
            ? CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content:
          new Text('These poses will be deleted forever!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                _controllerSlideUp.reverse();
                pageState.onDeletePosesSelected();
                pageState.onSelectAllSelected(false);
                setState(() {
                  isBottomSheetVisible = false;
                  selectAllChecked = false;
                });
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        )
            : AlertDialog(
          title: new Text('Are you sure?'),
          content:
          new Text('These poses will be deleted forever!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                _controllerSlideUp.reverse();
                pageState.onDeletePosesSelected();
                pageState.onSelectAllSelected(false);
                setState(() {
                  isBottomSheetVisible = false;
                  selectAllChecked = false;
                });
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
        store.dispatch(LoadPoseImagesFromStorage(store.state.poseGroupPageState, poseGroup));
      },
      converter: (Store<AppState> store) => PoseGroupPageState.fromStore(store),
      builder: (BuildContext context, PoseGroupPageState pageState) =>
          WillPopScope(
        onWillPop: () {
          pageState.onBackSelected();
          return Future.value(true);
        },
        child: Scaffold(
          floatingActionButton: !isBottomSheetVisible ? FloatingActionButton(
            onPressed: () {
              getDeviceImage(pageState);
            },
            backgroundColor: Color(ColorConstants.getPeachDark()),
            child: Container(
              height: 26.0,
              width: 26.0,
              child: Image.asset(
                'assets/images/icons/plus.png',
                color: Color(ColorConstants.getPrimaryWhite()),
              ),
            ),
          ) : SizedBox(),
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
                    title: Container(
                      child: Text(
                        !isBottomSheetVisible ? poseGroup.groupName : "Select Photos",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'simple',
                          color: Color(ColorConstants.getPeachDark()),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if(!isBottomSheetVisible) {
                            _controllerSlideUp.forward();
                            setState(() {
                              isBottomSheetVisible = true;
                            });
                          }else {
                            _controllerSlideUp.reverse();
                            setState(() {
                              isBottomSheetVisible = false;
                              selectAllChecked = false;
                              pageState.onSelectAllSelected(false);
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 22.0),
                          height: 28.0,
                          width: 28.0,
                          child: Icon(
                            !isBottomSheetVisible ? (Device.get().isIos ? CupertinoIcons.share : Icons.share) : Device.get().isIos ? CupertinoIcons.clear : Icons.close,
                            size: 28.0,
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                        ),
                      ),
                      !isBottomSheetVisible ? GestureDetector(
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
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        pageState.poseImages.length > 0
                            ? Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Container(
                            height: (MediaQuery.of(context).size.height),
                            child: GridView.builder(
                                padding: new EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 300.0),
                                gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 2 / 2.35,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                                itemCount: pageState.poseImages.length,
                                controller: _controller,
                                physics: AlwaysScrollableScrollPhysics(),
                                key: _listKey,
                                shrinkWrap: true,
                                reverse: false,
                                itemBuilder: _buildItem),
                          ),
                        )
                            : poseGroup.poses.length == 0 && !pageState.isLoadingNewImages ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 48.0,
                                  top: 48.0,
                                  right: 48.0,
                                  bottom: 32.0),
                              child: Text(
                                "You do not have any poses in this collection yet. Select the button below to add a pose.",
                                // \n\nYou can also share your saved locations with a client to help them decide what location they want.
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w400,
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
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
                                  child: Text(
                                    "Select Images",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(
                                          ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ) : !pageState.isLoadingNewImages ? Container(
                              margin: EdgeInsets.only(top: 250.0),
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: Color(ColorConstants.getPeachLight()),
                                size: 48,
                              ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: slideUpAnimation,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 8.0),
                    color: Color(ColorConstants.getPeachDark()),
                    height: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if(pageState.selectedImages.length > 0) {
                              pageState.onSharePosesSelected();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 26.0),
                            height: 24.0,
                            width: 24.0,
                            child: Icon(
                              Device.get().isIos ? CupertinoIcons.share : Icons.share,
                              size: 24.0,
                              color: Color(pageState.selectedImages.length > 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getPeachLight()),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Select All",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(
                                    selectAllChecked ? ColorConstants.getPrimaryWhite() : ColorConstants.getPeachLight()),
                              ),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Color(ColorConstants.getPeachLight()),
                              ),
                              child: Checkbox(
                                  checkColor: Color(ColorConstants.getPrimaryWhite()),
                                  activeColor: Color(ColorConstants.getPeachDark()),
                                  value: selectAllChecked,
                                  onChanged: (bool checked) {
                                    setState(() {
                                      selectAllChecked = checked;
                                      pageState.onSelectAllSelected(checked);
                                    });
                                  }
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if(pageState.selectedImages.length > 0) {
                              _ackAlertDeletePoses(context, pageState);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 26.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset(
                              'assets/images/icons/trashcan.png',
                              color: Color(pageState.selectedImages.length > 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getPeachLight()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              pageState.isLoadingNewImages ? Align(
                alignment: Alignment.center,
                child: Container(
                  height: 64.0,
                  width: 64.0,
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.getPeachLight()),
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    size: 32,
                  ),
                ),
              ) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
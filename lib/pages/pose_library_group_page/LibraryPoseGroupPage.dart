import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/AddLibraryPhotoBottomSheet.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/LibraryPoseListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';

import '../../models/PoseLibraryGroup.dart';
import '../../widgets/TextDandyLight.dart';
import 'LibraryPoseGroupActions.dart';
import 'LibrarySingleImageViewPager.dart';

class LibraryPoseGroupPage extends StatefulWidget {
  final PoseLibraryGroup poseGroup;

  LibraryPoseGroupPage(this.poseGroup);

  @override
  State<StatefulWidget> createState() {
    return _LibraryPoseGroupPageState(poseGroup);
  }
}

class _LibraryPoseGroupPageState extends State<LibraryPoseGroupPage>
    with TickerProviderStateMixin {
  final PoseLibraryGroup poseGroup;
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  _LibraryPoseGroupPageState(this.poseGroup);

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      converter: (store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => LibrarySingleImageViewPager(
                  pageState.poseImages,
                  index,
                  pageState.poseGroup.groupName,
                )),
              );
            },
            child: LibraryPoseListWidget(index),
          ),
    );
  }

  void _showAddImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return AddLibraryPhotoBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      onInit: (store) async {
        store.dispatch(LoadLibraryPoseImagesFromStorage(store.state.libraryPoseGroupPageState, poseGroup));
      },
      converter: (Store<AppState> store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          WillPopScope(
        onWillPop: () {
          pageState.onBackSelected();
          return Future.value(true);
        },
        child: Scaffold(
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
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: poseGroup.groupName,
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                    ),
                    actions: <Widget>[
                      pageState.isAdmin ? GestureDetector(
                        onTap: () {
                          _showAddImageBottomSheet(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 26.0),
                          height: 28.0,
                          width: 28.0,
                          child: Image.asset(
                            'assets/images/icons/plus.png',
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
                                    childAspectRatio: 2 / 2.45,
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
                            : poseGroup.poses.length == 0 && !pageState.isLoadingNewImages && pageState.isAdmin ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 48.0,
                                  top: 48.0,
                                  right: 48.0,
                                  bottom: 32.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: "You do not have any poses in this collection yet. Select the + button to add a pose.",
                                // \n\nYou can also share your saved locations with a client to help them decide what location they want.
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showAddImageBottomSheet(context);
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
                                  _showAddImageBottomSheet(context);
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
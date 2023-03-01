import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/poses_page/PoseSearchSingleImageViewPager.dart';
import 'package:dandylight/pages/poses_page/widgets/LibraryPoseSearchListWidget.dart';
import 'package:dandylight/pages/poses_page/widgets/PosesTextField.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'GoToJobPosesBottomSheet.dart';
import 'PosesActions.dart';
import 'PosesPageState.dart';

class PosesSearchPage extends StatefulWidget {
  final Job job;

  PosesSearchPage(this.job);

  @override
  State<StatefulWidget> createState() {
    return _PosesSearchPageState(job);
  }
}

class _PosesSearchPageState extends State<PosesSearchPage> {
  ScrollController _controller;
  final firstNameTextController = TextEditingController();
  Job job;

  _PosesSearchPageState(this.job);

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          GestureDetector(
            onTap: () {
              if(job == null) {
                Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => PoseSearchSingleImageViewPager(
                    pageState.searchResultsImages,
                    index,
                    'Search Results',
                  )),
                );
              } else {
                pageState.onImageAddedToJobSelected(pageState.searchResultsImages.elementAt(index).pose, job);
                VibrateUtil.vibrateMedium();
                DandyToastUtil.showToastWithGravity('Pose Added!', Color(ColorConstants.getPeachDark()), ToastGravity.CENTER);
                EventSender().sendEvent(eventName: EventNames.BT_SAVE_LIBRARY_SEARCH_POSE_TO_JOB_FROM_JOB);
              }
            },
            child: LibraryPoseSearchListWidget(index, job),
          ),
    );
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      KeyboardUtil.closeKeyboard(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      onInit: (store) async {
        store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
      },
      onDidChange: (previous, current) {
        if(firstNameTextController.text.isEmpty) {
          current.onSearchInputChanged('');
        }
        if(current.searchResultPoses.length > 0 && current.searchResultsImages.length == 0) {
          current.loadMoreImages();
        }
      },
      converter: (Store<AppState> store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          Scaffold(
            bottomSheet: job != null ? GoToJobPosesBottomSheet(job, 3) : SizedBox(),
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            body: CustomScrollView(
              controller: _controller,
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
                      text: "Search Poses",
                      color: Color(ColorConstants.getPeachDark()),
                  ),
                  elevation: 4.0,
                  pinned: true,
                  snap: false,
                  floating: true,
                  forceElevated: false,
                  expandedHeight: 140,
                  collapsedHeight: 64,
                  flexibleSpace: new FlexibleSpaceBar(
                    background: Column(
                      children: <Widget>[
                        SafeArea(
                          child: PreferredSize(
                            child: Container(
                              margin: EdgeInsets.only(left: 24, right: 24, top: 56.0),
                              child: PosesTextField(
                                controller: firstNameTextController,
                                hintText: 'Descriptive Words',
                                inputType: TextInputType.text,
                                height: 72.0,
                                onTextInputChanged: pageState.onSearchInputChanged,
                                keyboardAction: TextInputAction.done,
                                capitalization: TextCapitalization.words,
                                inputTypeError: '',
                              ),
                            ),
                            preferredSize: Size.fromHeight(44.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 128),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2.45,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16),
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        if(pageState.searchResultsImages.length < pageState.searchResultPoses.length) {
                          if(index >= pageState.searchResultsImages.length - 1) {
                            if(!pageState.isLoadingSearchImages) {
                              pageState.loadMoreImages();
                            }
                          }
                        }
                        return Container(
                          height: (MediaQuery.of(context).size.height),
                          child: _buildItem(context, index),
                        );
                      },
                      childCount: pageState.searchResultsImages.length, // 1000 list items
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      [
                        pageState.searchResultPoses.length == 0 ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          alignment: Alignment.bottomCenter,
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: 'Search by:',
                            color: Color(ColorConstants.getPeachDark()),
                            textAlign: TextAlign.center,
                          ),
                        ) : SizedBox(),
                        pageState.searchResultPoses.length == 0 ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                          alignment: Alignment.center,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Descriptive words or phrases, Instagram name or Instagram Url',
                            color: Color(ColorConstants.getPeachDark()),
                            textAlign: TextAlign.center,
                          ),
                        ) : SizedBox(),
                      ]
                    ),
                ),
              ],
            ),
          ),
    );

    }

  void onFirstNameAction(){

  }
  }

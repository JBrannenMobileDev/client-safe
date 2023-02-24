import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/poses_page/MyPosesPage.dart';
import 'package:dandylight/pages/poses_page/widgets/LibraryPoseSearchListWidget.dart';
import 'package:dandylight/pages/poses_page/widgets/PosesTextField.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../models/Job.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import '../pose_library_group_page/LibrarySingleImageViewPager.dart';
import '../pose_library_group_page/widgets/LibraryPoseListWidget.dart';
import 'PoseLibraryPage.dart';
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
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final firstNameTextController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  Job job;

  _PosesSearchPageState(this.job);

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => LibrarySingleImageViewPager(
                    pageState.searchResultsImages,
                    index,
                    'Search Results',
                    job
                )),
              );
            },
            child: LibraryPoseSearchListWidget(index, job),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      onInit: (store) async {
        store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
      },
      converter: (Store<AppState> store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          Scaffold(
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Color(
                        ColorConstants.getPeachDark()), //change your color here
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: "Search Poses",
                      color: Color(ColorConstants.getPeachDark()),
                  ),
                  elevation: 0.0,
                  pinned: false,
                  floating: false,
                  forceElevated: false,
                  expandedHeight: 128,
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
                                height: 64.0,
                                onTextInputChanged: pageState.onSearchInputChanged,
                                keyboardAction: TextInputAction.done,
                                capitalization: TextCapitalization.words,
                                focusNode: _firstNameFocus,
                                onFocusAction: onFirstNameAction,
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
            SliverList(
              delegate: new SliverChildListDelegate(
                <Widget>[
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      KeyboardUtil.closeKeyboard(context);
                      return true;
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Container(
                          height: (MediaQuery.of(context).size.height),
                          child: GridView.builder(
                              padding:
                              new EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 300.0),
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 2 / 2.45,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16),
                              itemCount: pageState.searchResultsImages.length,
                              controller: _controller,
                              physics: AlwaysScrollableScrollPhysics(),
                              key: _listKey,
                              shrinkWrap: true,
                              reverse: false,
                              itemBuilder: _buildItem),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
              ],
            ),
          ),
    );

    }

  void onFirstNameAction(){
    _firstNameFocus.unfocus();
  }
  }

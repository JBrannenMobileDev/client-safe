import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/jobs_page/widgets/JobCompletedItem.dart';
import 'package:dandylight/pages/jobs_page/JobsPageState.dart';
import 'package:dandylight/pages/jobs_page/widgets/JobsPageActiveJobsItem.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'JobsPageActions.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({Key key, this.comingFromMainNavigation}) : super(key: key);
  final bool comingFromMainNavigation;

  static const String FILTER_TYPE_ACTIVE_JOBS = "Active Jobs";
  static const String FILTER_TYPE_COMPETED = "Completed";

  @override
  State<StatefulWidget> createState() {
    return _JobsPageState(comingFromMainNavigation);
  }
}

class _JobsPageState extends State<JobsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();
  bool comingFromMainNavigation;

  _JobsPageState(this.comingFromMainNavigation);

  int selectorIndex = 0;
  Map<int, Widget> jobTypes;

  @override
  Widget build(BuildContext context) {
    jobTypes = <int, Widget>{
      0: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: JobsPage.FILTER_TYPE_ACTIVE_JOBS,
        color: Color(selectorIndex == 0
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
      1: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: JobsPage.FILTER_TYPE_COMPETED,
        color: Color(selectorIndex == 1
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
    };
    return StoreConnector<AppState, JobsPageState>(
        converter: (store) => JobsPageState.fromStore(store),
        onInit: (store) async {
          store.dispatch(FetchJobsAction(store.state.jobsPageState));
          if(comingFromMainNavigation) {
            store.dispatch(FilterChangedAction(store.state.jobsPageState, JobsPage.FILTER_TYPE_ACTIVE_JOBS));
          }
        },
        builder: (BuildContext context, JobsPageState pageState) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Colors.white,
                        pinned: true,
                        centerTitle: true,
                        title: Container(
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: "Jobs",
                            color: const Color(ColorConstants.primary_black),
                          ),
                        ),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              UserOptionsUtil.showNewJobDialog(context, false);
                              EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "Jobs Page"});
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 26.0),
                              height: 24.0,
                              width: 24.0,
                              child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPeachDark()),),
                            ),
                          ),
                        ],
                        bottom: PreferredSize(
                          child: Container(

                            margin: EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              thumbColor: Color(ColorConstants.getBlueDark()),
                              children: jobTypes,
                              onValueChanged: (int filterTypeIndex) {
                                setState(() {
                                  selectorIndex = filterTypeIndex;
                                });
                                pageState.onFilterChanged(filterTypeIndex == 0 ? JobsPage.FILTER_TYPE_ACTIVE_JOBS : JobsPage.FILTER_TYPE_COMPETED);
                              },
                              groupValue: selectorIndex,
                            ),
                          ),
                          preferredSize: Size.fromHeight(44.0),
                        ),
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            ListView.builder(
                              reverse: false,
                              padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                              shrinkWrap: true,
                              controller: _controller,
                              physics: ClampingScrollPhysics(),
                              key: _listKey,
                              itemCount: pageState.filterType == JobsPage.FILTER_TYPE_ACTIVE_JOBS ? pageState.activeJobs.length : pageState.jobsCompleted.length,
                              itemBuilder: _buildItem,
                            ),
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

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, JobsPageState>(
    converter: (store) => JobsPageState.fromStore(store),
    builder: (BuildContext context, JobsPageState pageState) =>
    pageState.filterType == JobsPage.FILTER_TYPE_ACTIVE_JOBS ? JobsPageActiveJobsItem(job: pageState.activeJobs.elementAt(index), pageState: pageState,)
        : JobCompletedItem(job: pageState.jobsCompleted.elementAt(index), pageState: pageState),
  );
}

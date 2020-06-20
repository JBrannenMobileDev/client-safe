import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobCompletedItem.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobInProgressItem.dart';
import 'package:dandylight/pages/jobs_page/JobsPageState.dart';
import 'package:dandylight/pages/jobs_page/widgets/JobsPageInProgressItem.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sider_bar/sider_bar.dart';

class JobsPage extends StatefulWidget {
  static const String FILTER_TYPE_IN_PROGRESS = "In Progress";
  static const String FILTER_TYPE_COMPETED = "Completed";
  static const String FILTER_TYPE_UPCOMING = "Upcoming";

  @override
  State<StatefulWidget> createState() {
    return _JobsPageState();
  }
}

class _JobsPageState extends State<JobsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();

  int selectorIndex = 0;
  Map<int, Widget> jobTypes;

  @override
  Widget build(BuildContext context) {
    jobTypes = <int, Widget>{
      0: Text(JobsPage.FILTER_TYPE_UPCOMING,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'simple',
          color: Color(selectorIndex == 0
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      1: Text(JobsPage.FILTER_TYPE_IN_PROGRESS,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'simple',
          color: Color(selectorIndex == 1
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      2: Text(JobsPage.FILTER_TYPE_COMPETED,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'simple',
          color: Color(selectorIndex == 2
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
    };
    return StoreConnector<AppState, JobsPageState>(
        converter: (store) => JobsPageState.fromStore(store),
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
                        title: Center(
                          child: Text(
                            "Jobs",
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'simple',
                              color: const Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              UserOptionsUtil.showNewJobDialog(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12.0),
                              height: 24.0,
                              width: 24.0,
                              child: Image.asset('assets/images/icons/plus_icon_peach.png'),
                            ),
                          ),
                        ],
                        bottom: PreferredSize(
                          child: Container(

                            margin: EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              thumbColor: Color(ColorConstants.getPrimaryColor()),
                              children: jobTypes,
                              onValueChanged: (int filterTypeIndex) {
                                setState(() {
                                  selectorIndex = filterTypeIndex;
                                });
                                pageState.onFilterChanged(filterTypeIndex == 0 ? JobsPage.FILTER_TYPE_UPCOMING : filterTypeIndex == 1 ? JobsPage.FILTER_TYPE_IN_PROGRESS : JobsPage.FILTER_TYPE_COMPETED);
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
                              itemCount: pageState.filterType == JobsPage.FILTER_TYPE_UPCOMING ? pageState.jobsUpcoming.length : pageState.filterType == JobsPage.FILTER_TYPE_IN_PROGRESS ? pageState.jobsInProgress.length : pageState.jobsCompleted.length,
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
    pageState.filterType == JobsPage.FILTER_TYPE_UPCOMING ? JobsPageInProgressItem(job: pageState.jobsUpcoming.elementAt(index), pageState: pageState,)
        : pageState.filterType == JobsPage.FILTER_TYPE_IN_PROGRESS ? JobsPageInProgressItem(job: pageState.jobsInProgress.elementAt(index), pageState: pageState,) : JobCompletedItem(job: pageState.jobsCompleted.elementAt(index), pageState: pageState),
  );
}

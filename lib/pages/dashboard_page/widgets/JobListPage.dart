import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobInProgressItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../models/JobStage.dart';
import '../../../utils/JobUtil.dart';
import '../../../widgets/TextDandyLight.dart';

class JobListPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  JobListPage({
    this.pageState,
    this.pageTitle,
    this.stage,
    this.isActiveJobs
  });

  final DashboardPageState pageState;
  final String pageTitle;
  List<Job> jobs;
  final JobStage stage;
  final bool isActiveJobs;

  @override
  Widget build(BuildContext context)=> StoreConnector<AppState, DashboardPageState>(
      converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
      onInit: (store) {
        jobs = stage != null ? JobUtil.getJobsForStage(store.state.dashboardPageState.activeJobs, stage) : isActiveJobs ? store.state.dashboardPageState.activeJobs : store.state.dashboardPageState.jobsThisWeek;
      },
      onDidChange: (previousPageState, currentPageState) {
        jobs = stage != null ? JobUtil.getJobsForStage(currentPageState.activeJobs, stage) : isActiveJobs ? currentPageState.activeJobs : currentPageState.jobsThisWeek;
      },
      builder: (BuildContext context, DashboardPageState pageState) => Scaffold(
      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
      body: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                pinned: true,
                floating: false,
                forceElevated: false,
                centerTitle: true,
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: pageTitle,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  color: Color(ColorConstants.getPrimaryColor()),
                  tooltip: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    ListView.builder(
                      reverse: false,
                      padding: new EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 64.0),
                      shrinkWrap: true,
                      controller: _controller,
                      physics: ClampingScrollPhysics(),
                      key: _listKey,
                      itemCount: jobs != null ? jobs.length : 0,
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


  Widget _buildItem(BuildContext context, int index) {
    return JobInProgressItem(job: jobs.elementAt(index), pageState: pageState);
  }

}
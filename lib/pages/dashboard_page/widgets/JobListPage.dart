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

class JobListPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  JobListPage({
    this.pageState,
    this.pageTitle,
    this.stage,
  });

  final DashboardPageState pageState;
  final String pageTitle;
  List<Job> jobs;
  final JobStage stage;

  @override
  Widget build(BuildContext context)=> StoreConnector<AppState, DashboardPageState>(
      converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
      onInit: (store) {
        jobs = stage != null ? JobUtil.getJobsForStage(store.state.dashboardPageState.activeJobs, stage) : store.state.dashboardPageState.activeJobs;
      },
      onDidChange: (previousPageState, currentPageState) {
        jobs = stage != null ? JobUtil.getJobsForStage(currentPageState.activeJobs, stage) : currentPageState.activeJobs;
      },
      builder: (BuildContext context, DashboardPageState pageState) => Scaffold(
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
                floating: false,
                forceElevated: false,
                centerTitle: true,
                title: Text(
                  pageTitle,
                  style: TextStyle(
                    fontSize: 26.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: const Color(ColorConstants.primary_black),
                  ),
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
                      itemCount: jobs.length,
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
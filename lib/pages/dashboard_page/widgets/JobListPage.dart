import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobInProgressItem.dart';
import 'package:dandylight/pages/home_page/HomePage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/styles/Styles.dart';

class JobListPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  JobListPage({
    this.pageState,
    this.pageTitle,
    this.jobs,
  });

  final DashboardPageState pageState;
  final String pageTitle;
  final List<Job> jobs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return JobInProgressItem(job: jobs.elementAt(index), pageState: pageState);
  }

}
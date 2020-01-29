import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobInProgressItem.dart';
import 'package:client_safe/pages/jobs_page/JobsPageActions.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sider_bar/sider_bar.dart';

class JobsPage extends StatefulWidget {
  static const String FILTER_TYPE_IN_PROGRESS = "In Progress";
  static const String FILTER_TYPE_COMPETED = "Completed";
  static const String FILTER_TYPE_ALL = "All";

  @override
  State<StatefulWidget> createState() {
    return _JobsPageState();
  }
}

class _JobsPageState extends State<JobsPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final String alphabet = "ABCDEFGHIGKLMNOPQRSTUVWXYZ";
  ScrollController _controller = ScrollController();
  final Map<int, Widget> genders = const <int, Widget>{
    0: Text(JobsPage.FILTER_TYPE_IN_PROGRESS),
    1: Text(JobsPage.FILTER_TYPE_COMPETED),
    2: Text(JobsPage.FILTER_TYPE_ALL),
  };
  List<String> alphabetList;

  @override
  void initState() {
    super.initState();
    alphabetList = List<String>.generate(alphabet.length, (index) => alphabet[index]);
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, JobsPageState>(
        onInit: (store) => store.dispatch(FetchJobsAction(store.state.jobsPageState)),
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
                              fontFamily: 'Raleway',
                              color: const Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: Color(ColorConstants.getPrimaryColor()),
                            tooltip: 'Add',
                            onPressed: () {
                              UserOptionsUtil.showDashboardOptionsSheet(context);
                            },
                          ),
                        ],
                        bottom: PreferredSize(
                          child: Container(
                            width: 300.0,
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSegmentedControl<int>(
                              borderColor: Color(ColorConstants.getPrimaryColor()),
                              selectedColor: Color(ColorConstants.getPrimaryColor()),
                              unselectedColor: Colors.white,
                              children: genders,
                              onValueChanged: (int filterTypeIndex) {
                                pageState.onFilterChanged(
                                    filterTypeIndex == 0
                                        ? JobsPage.FILTER_TYPE_IN_PROGRESS : filterTypeIndex == 1
                                        ? JobsPage.FILTER_TYPE_COMPETED : JobsPage.FILTER_TYPE_ALL);
                              },
                              groupValue: pageState.filterType == JobsPage.FILTER_TYPE_IN_PROGRESS ? 0 : pageState.filterType == JobsPage.FILTER_TYPE_COMPETED ? 1 : 2,
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
                              itemCount: pageState.filterType == JobsPage.FILTER_TYPE_ALL
                                  ? pageState.allJobs.length : pageState.filterType == JobsPage.FILTER_TYPE_IN_PROGRESS
                                  ? pageState.jobsInProgress.length : pageState.jobsCompleted.length,
                              itemBuilder: _buildItem,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SideBar(
                      list: alphabetList,
                      textColor: Color(ColorConstants.getPrimaryColor()),
                      color: Color(ColorConstants.getPrimaryColor()).withOpacity(0.2),
                      valueChanged: (value) {
                        _controller.jumpTo(alphabetList.indexOf(value) * 44.0);
                      })
                ],
          ),
        ),
      );
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, JobsPageState>(
    converter: (store) => JobsPageState.initial(),
    builder: (BuildContext context, JobsPageState pageState) =>
        JobInProgressItem(job: _getJobBasedOnFilter(pageState, index)),
  );
}

Job _getJobBasedOnFilter(JobsPageState pageState, int index) {
  switch(pageState.filterType){
    case JobsPage.FILTER_TYPE_IN_PROGRESS:
      return pageState.jobsInProgress.elementAt(index);
      break;
    case JobsPage.FILTER_TYPE_COMPETED:
      return pageState.jobsCompleted.elementAt(index);
    case JobsPage.FILTER_TYPE_ALL:
      return pageState.allJobs.elementAt(index);
  }
  return pageState.allJobs.elementAt(index);
}

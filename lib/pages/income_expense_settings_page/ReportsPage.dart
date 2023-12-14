import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Report.dart';
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
import 'ReportItem.dart';

class ReportsPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  ReportsPage({Key key,
    this.pageTitle,
    this.reports
  }) : super(key: key);

  final String pageTitle;
  final List<Report> reports;

  @override
  Widget build(BuildContext context)=> StoreConnector<AppState, DashboardPageState>(
      converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
      onInit: (store) {

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
                delegate: SliverChildListDelegate(
                  <Widget>[
                    ListView.builder(
                      reverse: false,
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 64.0),
                      shrinkWrap: true,
                      controller: _controller,
                      physics: const ClampingScrollPhysics(),
                      key: _listKey,
                      itemCount: reports.length,
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
    return ReportItem(report: reports.elementAt(index));
  }

}
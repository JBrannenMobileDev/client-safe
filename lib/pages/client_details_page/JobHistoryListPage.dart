import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/client_details_page/JobHistoryItem.dart';
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
import '../../widgets/TextDandyLight.dart';
import 'ClientDetailsPageState.dart';

class JobHistoryListPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context)=> StoreConnector<AppState, ClientDetailsPageState>(
      converter: (Store<AppState> store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) => Scaffold(
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
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Job History',
                  color: const Color(ColorConstants.primary_black),
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
                      itemCount: pageState.clientJobs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return JobHistoryItem(job: pageState.clientJobs.elementAt(index), pageState: pageState,);
                      },
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
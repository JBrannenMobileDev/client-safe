import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Report.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobInProgressItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../models/JobStage.dart';
import '../../../utils/JobUtil.dart';
import '../../../widgets/TextDandyLight.dart';
import 'IncomeAndExpenseSettingsPageState.dart';
import 'ReportItem.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key,
    this.pageTitle,
  }) : super(key: key);

  final String? pageTitle;

  @override
  State<StatefulWidget> createState() {
    return _ReportsPageState(pageTitle);
  }
}

class _ReportsPageState extends State<ReportsPage> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();
  final String? pageTitle;

  _ReportsPageState(this.pageTitle);

  @override
  Widget build(BuildContext context)=> StoreConnector<AppState, IncomeAndExpenseSettingsPageState>(
      converter: (Store<AppState> store) => IncomeAndExpenseSettingsPageState.fromStore(store),
      onInit: (store) {

      },
      builder: (BuildContext context, IncomeAndExpenseSettingsPageState pageState) => Scaffold(
      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
      body: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
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
                      itemCount: pageTitle == Report.TYPE_INCOME_EXPENSE ? pageState.incomeExpenseReports.length : pageState.mileageReports.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ReportItem(report: pageTitle == Report.TYPE_INCOME_EXPENSE ? pageState.incomeExpenseReports.elementAt(index) : pageState.mileageReports.elementAt(index));
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
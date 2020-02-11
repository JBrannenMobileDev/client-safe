import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:client_safe/pages/job_details_page/ClientDetailsCard.dart';
import 'package:client_safe/pages/job_details_page/JobInfoCard.dart';
import 'package:client_safe/pages/job_details_page/RemindersCard.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/ContractSentItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/ContractSignedItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/DepositReceivedItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/EditingCompleteItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/FeedbackReceivedItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/FeedbackRequestedItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/FollowupSentItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/GallerySentItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/InquiryReceivedItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/JobCompleteItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/PaymentReceivedItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/PaymentRequestedItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/PlanningCompleteItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/SessionCompleteItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({Key key, this.destination}) : super(key: key);
  final JobDetailsPage destination;

  @override
  State<StatefulWidget> createState() {
    return _JobDetailsPageState();
  }
}

class _JobDetailsPageState extends State<JobDetailsPage> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _scrollController;
  ScrollController _stagesScrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _stagesScrollController = ScrollController();

  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, DashboardPageState>(
        onInit: (store) => {
          store.dispatch(
              new InitDashboardPageAction(store.state.dashboardPageState)),
          store.dispatch(new LoadJobsAction(store.state.dashboardPageState)),
        },
        onDispose: (store) => store.dispatch(
            new DisposeDataListenersActions(store.state.homePageState)),
        converter: (Store<AppState> store) =>
            DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) =>
            Scaffold(
              body: Container(
                color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.getPrimaryColor()),
                        image: DecorationImage(
                          image: AssetImage(ImageUtil.DANDY_BG),
                          repeat: ImageRepeat.repeat,
                          fit: BoxFit.contain,
                        ),
                      ),
                      height: 435.0,
                    ),
                    CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        new SliverAppBar(
                          brightness: Brightness.light,
                          title: Text(
                            'Brannen Family Shoot',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Blackjack',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                          centerTitle: true,
                          titleSpacing: 48.0,
                          backgroundColor:
                          _isMinimized ? _getAppBarColor() : Colors.transparent,
                          elevation: 0.0,
                          pinned: true,
                          floating: false,
                          forceElevated: false,
                          expandedHeight: 325.0,
                          actions: <Widget>[
                            new IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete Job',
                              onPressed: () {},
                            ),
                          ],
                          flexibleSpace: new FlexibleSpaceBar(
                            background: Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 56.0),
                                  alignment: Alignment.topCenter,
                                  child: SafeArea(
                                    child: Text(
                                      'Job Stages',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black26,
                                      ),
                                    ),
                                  ),
                                ),
                                SafeArea(
                                  child: Container(
                                    height: 316.0,
                                    margin: EdgeInsets.only(top: 0.0),
                                    child: ListView(
                                      key: _listKey,
                                      scrollDirection: Axis.horizontal,
                                      controller: _stagesScrollController,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 32.0,
                                        ),
                                        InquiryReceivedItem(),
                                        FollowupSentItem(),
                                        ContractSentItem(),
                                        ContractSignedItem(),
                                        DepositReceivedItem(),
                                        PlanningCompleteItem(),
                                        SessionCompleteItem(),
                                        PaymentRequestedItem(),
                                        PaymentReceivedItem(),
                                        EditingCompleteItem(),
                                        GallerySentItem(),
                                        FeedbackRequestedItem(),
                                        FeedbackReceivedItem(),
                                        JobCompleteItem(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        new SliverList(
                            delegate: new SliverChildListDelegate(<Widget>[
                              RemindersCard(),
                              JobInfoCard(),
                              ClientDetailsCard(),
                            ])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      );

  void _onAddButtonPressed(BuildContext context) {
    UserOptionsUtil.showDashboardOptionsSheet(context);
  }

  bool get _isMinimized {
    return _scrollController.hasClients && _scrollController.offset > 260.0;
  }

  Color _getAppBarColor() {
    if (_scrollController.offset > 260 && _scrollController.offset <= 262) {
      return Colors.black.withOpacity(0.08);
    } else if (_scrollController.offset > 262 &&
        _scrollController.offset <= 263) {
      return Colors.black.withOpacity(0.09);
    } else if (_scrollController.offset > 263 &&
        _scrollController.offset <= 264) {
      return Colors.black.withOpacity(0.10);
    } else if (_scrollController.offset > 264 &&
        _scrollController.offset <= 265) {
      return Colors.black.withOpacity(0.11);
    } else if (_scrollController.offset > 265 &&
        _scrollController.offset <= 266) {
      return Colors.black.withOpacity(0.12);
    } else if (_scrollController.offset > 266 &&
        _scrollController.offset <= 267) {
      return Colors.black.withOpacity(0.13);
    } else if (_scrollController.offset > 267 &&
        _scrollController.offset <= 268) {
      return Colors.black.withOpacity(0.15);
    } else if (_scrollController.offset > 268 &&
        _scrollController.offset <= 269) {
      return Colors.black.withOpacity(0.17);
    } else if (_scrollController.offset > 269 &&
        _scrollController.offset <= 270) {
      return Colors.black.withOpacity(0.19);
    } else if (_scrollController.offset > 270 &&
        _scrollController.offset <= 271) {
      return Colors.black.withOpacity(0.22);
    } else if (_scrollController.offset > 272 &&
        _scrollController.offset <= 273) {
      return Colors.black.withOpacity(0.24);
    } else {
      return Colors.black.withOpacity(0.26);
    }
  }
}

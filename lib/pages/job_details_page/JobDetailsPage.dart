import 'dart:async';
import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/job_details_page/ClientDetailsCard.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
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

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({Key key, this.destination}) : super(key: key);
  final JobDetailsPage destination;

  @override
  State<StatefulWidget> createState() {
    return _JobDetailsPageState();
  }
}

class _JobDetailsPageState extends State<JobDetailsPage> with TickerProviderStateMixin{
  final GlobalKey<AnimatedListState> _listKeyVertical = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _listKeyStates = GlobalKey<AnimatedListState>();
  ScrollController _scrollController;
  ScrollController _stagesScrollController = ScrollController();
  double scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, JobDetailsPageState>(
        converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
        builder: (BuildContext context, JobDetailsPageState pageState) {
          Timer(Duration(milliseconds: 500), () => _stagesScrollController.animateTo(
            _getScrollToOffset(pageState),
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 1500),
          ));
              return Scaffold(
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
                      key: _listKeyVertical,
                      controller: _scrollController,
                      slivers: <Widget>[
                        new SliverAppBar(
                          brightness: Brightness.light,
                          title: Text(
                            pageState.job.jobTitle,
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _stagesScrollController,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                            height: 347.0,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              physics: NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.all(16.0),
                                              itemCount: 15,
                                              itemBuilder: _buildItem,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),





//                                  Container(
//                                    height: 316.0,
//                                    margin: EdgeInsets.only(top: 0.0),
//                                    child:ListView.builder(
//                                      scrollDirection: Axis.horizontal,
//                                      controller: _stagesScrollController,
//                                      itemCount: 15,
//                                      itemBuilder: _buildItem,
//                                    ),
////                                    ListView(
////                                      key: _listKeyStates,
////                                      cacheExtent: 15,
////                                      addAutomaticKeepAlives: true,
////                                      scrollDirection: Axis.horizontal,
////                                      controller: _stagesScrollController,
////                                      children: <Widget>[
////                                        SizedBox(
////                                          width: 32.0,
////                                        ),
////                                        InquiryReceivedItem(),
////                                        FollowupSentItem(),
////                                        ContractSentItem(),
////                                        ContractSignedItem(),
////                                        DepositReceivedItem(),
////                                        PlanningCompleteItem(),
////                                        SessionCompleteItem(),
////                                        PaymentRequestedItem(),
////                                        PaymentReceivedItem(),
////                                        EditingCompleteItem(),
////                                        GallerySentItem(),
////                                        FeedbackRequestedItem(),
////                                        FeedbackReceivedItem(),
////                                        JobCompleteItem(),
////                                      ],
////                                    ),
//                                  ),
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
            );
        },
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

  double _getScrollToOffset(JobDetailsPageState pageState) {
    switch(pageState.job.)
    return 232.0;
  }
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, JobDetailsPageState>(
    converter: (store) => JobDetailsPageState.fromStore(store),
    builder: (BuildContext context, JobDetailsPageState pageState) => _getWidgetForIndex(index),
  );
}

_getWidgetForIndex(int index) {
  switch(index){
    case 0:
      return SizedBox(width: 32.0);
    case 1:
      return InquiryReceivedItem();
    case 2:
      return FollowupSentItem();
    case 3:
      return ContractSentItem();
    case 4:
      return ContractSignedItem();
    case 5:
      return DepositReceivedItem();
    case 6:
      return PlanningCompleteItem();
    case 7:
      return SessionCompleteItem();
    case 8:
      return PaymentRequestedItem();
    case 9:
      return PaymentReceivedItem();
    case 10:
      return EditingCompleteItem();
    case 11:
      return GallerySentItem();
    case 12:
      return FeedbackRequestedItem();
    case 13:
      return FeedbackReceivedItem();
    case 14:
      return JobCompleteItem();
  }
  return 0;
}

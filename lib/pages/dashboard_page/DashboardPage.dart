import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/BaseHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPage.dart';
import 'package:client_safe/pages/new_job_page/NewJobPage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key, this.destination}) : super(key: key);
  final DashboardPage destination;

  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, DashboardPageState>(
        onInit: (store) =>
            store.dispatch(
                new InitDashboardPageAction(store.state.dashboardPageState)),
        onDispose: (store) =>
            store.dispatch(
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
                          backgroundColor: _isMinimized ? _getAppBarColor() : Colors.transparent,
                          elevation: 0.0,
                          pinned: true,
                          floating: false,
                          forceElevated: false,
                          expandedHeight: 315.0,
                          actions: <Widget>[
                            new IconButton(
                              icon: const Icon(Icons.search),
                              tooltip: 'Search',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              tooltip: 'Add',
                              onPressed: () {
                                _onAddButtonPressed(context);
                              },
                            ),
                            new IconButton(
                              icon: const Icon(Icons.settings),
                              tooltip: 'Settings',
                              onPressed: () {},
                            ),
                          ],
                          flexibleSpace: new FlexibleSpaceBar(
                            background: Stack(
                              children: <Widget>[
                                Container(
                                  height: 150.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        new SliverList(
                            delegate: new SliverChildListDelegate(<Widget>[
                              JobsHomeCard(pageState: pageState),
                              StatsHomeCard(cardTitle: "Stats", pageState: pageState),
                            ])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      );

  void _onAddButtonPressed(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Add New Contact"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewContactPage();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.business_center),
                  title: Text("Start New Job"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewJobPage();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.folder),
                  title: Text("Add to Collection"),
                  onTap: () {},
                ),
              ],
            ),
          );
        });
  }

  bool get _isMinimized {
    return _scrollController.hasClients
        && _scrollController.offset > 260.0;
  }

  Color _getAppBarColor(){
    if(_scrollController.offset > 260 && _scrollController.offset <= 262){
      return Colors.black.withOpacity(0.08);
    }else if(_scrollController.offset > 262 && _scrollController.offset <= 263){
      return Colors.black.withOpacity(0.09);
    }else if(_scrollController.offset > 263 && _scrollController.offset <= 264){
      return Colors.black.withOpacity(0.10);
    }else if(_scrollController.offset > 264 && _scrollController.offset <= 265){
      return Colors.black.withOpacity(0.11);
    }else if(_scrollController.offset > 265 && _scrollController.offset <= 266){
      return Colors.black.withOpacity(0.12);
    }else if(_scrollController.offset > 266 && _scrollController.offset <= 267){
      return Colors.black.withOpacity(0.13);
    }else if(_scrollController.offset > 267 && _scrollController.offset <= 268){
      return Colors.black.withOpacity(0.15);
    }else if(_scrollController.offset > 268 && _scrollController.offset <= 269){
      return Colors.black.withOpacity(0.17);
    }else if(_scrollController.offset > 269 && _scrollController.offset <= 270){
      return Colors.black.withOpacity(0.19);
    }else if(_scrollController.offset > 270 && _scrollController.offset <= 271){
      return Colors.black.withOpacity(0.22);
    }else if(_scrollController.offset > 272 && _scrollController.offset <= 273){
      return Colors.black.withOpacity(0.24);
    } else {
      return Colors.black.withOpacity(0.26);
    }
  }
}

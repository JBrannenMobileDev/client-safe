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

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key key, this.destination}) : super(key: key);

  final DashboardPage destination;

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
                        color: Color(ColorConstants.getPrimaryColorForDashboard()).withOpacity(0.75),
                        image: DecorationImage(
                          image: AssetImage(ImageUtil.CAMERA_BG),
                          repeat: ImageRepeat.repeat,
                          colorFilter: new ColorFilter.mode(
                              Colors.white.withOpacity(0.05),
                              BlendMode.dstATop),
                          fit: BoxFit.contain,
                        ),
                      ),
                      height: 435.0,
                    ),
                    CustomScrollView(
                      slivers: <Widget>[
                        new SliverAppBar(
                          brightness: Brightness.light,
                          backgroundColor: Colors.transparent,
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
}

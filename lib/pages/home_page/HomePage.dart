import 'package:client_safe/pages/actions_page/ActionsPage.dart';
import 'package:client_safe/pages/clients_page/ClientsPage.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPage.dart';
import 'package:client_safe/pages/jobs_page/JobsPage.dart';
import 'package:client_safe/pages/marketing_page/MarketingPage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  int _currentIndex = 2;
  final List<Widget> _children = [
    ClientsPage(),
    JobsPage(),
    DashboardPage(),
    ActionsPage(),
    MarketingPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(ColorConstants.primary),
        title: const Text('Vintage Vibes Photography'),
        elevation: 0.0,
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _onSettingsSelected();
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(ColorConstants.primary_bg_grey),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: const Color(ColorConstants.primary_accent),
          onTap: onTabTapped,
          currentIndex: _currentIndex, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.people,
              ),
              title: new Text('Clients'),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.photo_camera,
                ),
                title: Text('Jobs')),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.dashboard,
              ),
              title: new Text('Dashboard'),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.directions_run,
                ),
                title: Text('Actions')),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.stars,
                ),
                title: Text('Marketing'))
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onSettingsSelected() {}
}

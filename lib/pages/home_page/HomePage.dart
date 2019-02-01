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
      body: _children[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(ColorConstants.primary_dark),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
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
                  Icons.assignment_ind,
                ),
                title: Text('Leads')),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.dashboard,
              ),
              title: new Text('Dashboard'),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.photo_camera,
                ),
                title: Text('Jobs')),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_today,
                ),
                title: Text('Calendar'))
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

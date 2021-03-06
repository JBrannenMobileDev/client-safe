import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPage.dart';
import 'package:dandylight/pages/collections_page/CollectionsPage.dart';
import 'package:dandylight/pages/clients_page/ClientsPage.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPage.dart';
import 'package:dandylight/pages/jobs_page/JobsPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  int _currentIndex = 2;
  List<Widget> _children = [
    ClientsPage(),
    IncomeAndExpensesPage(),
    DashboardPage(comingFromLogin: true),
    JobsPage(),
    CollectionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      backgroundColor: Color(ColorConstants.getBlueLight()),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(ColorConstants.getBlueLight()),
          primaryColor: Color(ColorConstants.primary_black),
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(
                caption: new TextStyle(
                    color: Color(ColorConstants.primary_button_negative_grey)
                )
          ),
      ),
        child:  Container(
            color: Color(ColorConstants.getBlueLight()),
            child: BottomNavigationBar(
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              onTap: onTabTapped,
              currentIndex: _currentIndex, // this will be set when a new tab is tapped
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.people,
                      size: 30.0,
                      color: _currentIndex == 0 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                    title: Container(height: 0.0)),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.monetization_on,
                      size: 28.0,
                      color: _currentIndex == 1 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                    title: Container(height: 0.0)),
                BottomNavigationBarItem(
                    icon: Image.asset('assets/images/menu/home_icon.png',
                      height: 26.0,
                      width: 26.0,
                      color: _currentIndex == 2 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                    title: Container(height: 0.0)),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.business_center,
                      size: 28.0,
                      color: _currentIndex == 3 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                    title: Container(height: 0.0)),
                BottomNavigationBarItem(
                    icon: Image.asset('assets/images/menu/collections_icon.png',
                      height: 22.0,
                      width: 22.0,
                      color: _currentIndex == 4 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                    title: Container(height: 0.0)),
              ],
            ),
          ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _children = [
        ClientsPage(),
        IncomeAndExpensesPage(),
        DashboardPage(comingFromLogin: false),
        JobsPage(),
        CollectionsPage(),
      ];
      _currentIndex = index;
    });
  }

  void _onSettingsSelected() {}
}

import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPage.dart';
import 'package:dandylight/pages/collections_page/CollectionsPage.dart';
import 'package:dandylight/pages/clients_page/ClientsPage.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPage.dart';
import 'package:dandylight/pages/jobs_page/JobsPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';

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
          primaryColor: Color(ColorConstants.getPrimaryBlack()),
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
            child: Stack(
              children: [
                BottomNavigationBar(
                  backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                  elevation: 0.0,
                  type: BottomNavigationBarType.fixed,
                  onTap: onTabTapped,
                  currentIndex: _currentIndex, // this will be set when a new tab is tapped
                  items: [
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset('assets/images/icons/contact_book.png',
                        height: 26.0,
                        width: 26.0,
                        color: _currentIndex == 0 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getBlueLight()),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset('assets/images/icons/income_expense.png',
                        height: 26.0,
                        width: 26.0,
                        color: _currentIndex == 1 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getBlueLight()),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset('assets/images/menu/home_icon.png',
                        height: 26.0,
                        width: 26.0,
                        color: _currentIndex == 2 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getBlueLight()),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "",
                      icon: Icon(
                        Icons.business_center,
                        size: 28.0,
                        color: _currentIndex == 3 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getBlueLight()),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "",
                      icon: Image.asset('assets/images/menu/collections_icon.png',
                        height: 22.0,
                        width: 22.0,
                        color: _currentIndex == 4 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getBlueLight()),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 0.5,
                  width: MediaQuery.of(context).size.width,
                  color: Color(ColorConstants.getBlueLight()),
                )
              ],
            ),
          ),
      ),
    );
  }

  void onTabTapped(int index) {
    switch(index) {
      case 0:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_CONTACTS);
        break;
      case 1:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_INCOME);
        break;
      case 2:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_DASHBOARD);
        break;
      case 3:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_JOBS);
        break;
      case 4:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_COLLECTIONS);
        break;
    }

    setState(() {
      _children = [
        ClientsPage(),
        IncomeAndExpensesPage(),
        DashboardPage(comingFromLogin: false),
        JobsPage(comingFromMainNavigation: true),
        CollectionsPage(),
      ];
      _currentIndex = index;
    });
  }

  void _onSettingsSelected() {}
}

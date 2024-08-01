import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPage.dart';
import 'package:dandylight/pages/booking_page/BookingPage.dart';
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
    const DashboardPage(comingFromLogin: true),
    BookingPage(),
    const CollectionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      backgroundColor: Color(ColorConstants.getBlueLight()),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(ColorConstants.getBlueLight()),
          primaryColor: Color(ColorConstants.getPrimaryBlack()),
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(),
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
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }

    setState(() {
      _children = [
        ClientsPage(),
        IncomeAndExpensesPage(),
        DashboardPage(comingFromLogin: false),
        BookingPage(),
        CollectionsPage(),
      ];
      _currentIndex = index;
    });
  }

  void _onSettingsSelected() {}
}

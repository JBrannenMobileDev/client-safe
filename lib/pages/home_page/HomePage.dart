import 'package:client_safe/models/ClientListItem.dart';
import 'package:client_safe/models/LeadListItem.dart';
import 'package:client_safe/models/ListItem.dart';
import 'package:client_safe/models/TitleListItem.dart';
import 'package:client_safe/pages/collections_page/CollectionsPage.dart';
import 'package:client_safe/pages/clients_page/ClientsPage.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPage.dart';
import 'package:client_safe/pages/jobs_page/JobsPage.dart';
import 'package:client_safe/pages/messages_page/MessagesPage.dart';
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
    MessagesPage(getLeadList()),
    DashboardPage(),
    JobsPage(),
    CollectionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
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
        child: BottomNavigationBar(
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _currentIndex, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.people,
              ),
              title: Container(height: 0.0)),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                title: Container(height: 0.0)),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.home,
              ),
              title: Container(height: 0.0)),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.business_center,
                ),
                title: Container(height: 0.0)),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.folder,
                ),
                title: Container(height: 0.0))
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

  static List<ListItem> _getClientList(){
    List<ListItem> result = List();
    result.add(TitleListItem("A"));
    for(var i = 0; i < 30; i++){
      ClientListItem client = ClientListItem("Shawna Brannen", "(951)295-0348", DateTime.now());
      result.add(client);
      if(i%5 == 0){
        result.add(TitleListItem("B"));
      }
    }
    return result;
  }

  static List<LeadListItem> getLeadList(){
    List<LeadListItem> leads = List();
    for(var i = 0; i < 30; i++){
      leads.add(LeadListItem("Shawna Brannen", DateTime.now(), "(951)294-0348"));
    }
    return leads;
  }
}

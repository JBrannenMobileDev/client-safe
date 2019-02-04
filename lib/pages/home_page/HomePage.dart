import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/ClientListItem.dart';
import 'package:client_safe/models/JobListItem.dart';
import 'package:client_safe/models/LeadListItem.dart';
import 'package:client_safe/models/ListItem.dart';
import 'package:client_safe/models/TitleListItem.dart';
import 'package:client_safe/pages/calendar_page/CalendarPage.dart';
import 'package:client_safe/pages/clients_page/ClientsPage.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPage.dart';
import 'package:client_safe/pages/jobs_page/JobsPage.dart';
import 'package:client_safe/pages/leads_page/LeadsPage.dart';
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
    ClientsPage(clients: _getClientList()),
    LeadsPage(getLeadList()),
    DashboardPage(),
    JobsPage(getJobList()),
    CalendarPage()
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

  static List<JobListItem> getJobList(){
    List<JobListItem> jobs = List();
    for(var i = 0; i < 30; i++){
      jobs.add(JobListItem("Maternity Shoot", "Shawna Brannen", DateTime.now()));
    }
    return jobs;
  }
}

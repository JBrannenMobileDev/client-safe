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
  final List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        color: const Color(ColorConstants.primary_bg_grey),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(ColorConstants.primary_dark),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: const Color(ColorConstants.primary_bg_grey),
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
}

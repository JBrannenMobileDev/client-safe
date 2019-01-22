import 'package:client_safe/utils/HostDetectionUtil.dart';
import 'package:flutter/material.dart';

class DashboardMessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: HostDetectionUtil.isIos(context) ? EdgeInsets.fromLTRB(40.0, 56.0, 0.0, 0.0) : EdgeInsets.fromLTRB(40.0, 42.0, 0.0, 0.0),
          child: Text(
            "Client Management",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Blackjack',
                color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(56.0, 0.0, 0.0, 0.0),
          child: Text(
            "With a Personal",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Blackjack',
                color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(88.0, 0.0, 0.0, 0.0),
          child: Text(
            "Touch!",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Blackjack',
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}

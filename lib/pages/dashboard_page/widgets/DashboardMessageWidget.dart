import 'package:flutter/material.dart';

class DashboardMessageWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(36.0, 48.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Happier Clients",
            style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Blackjack',
                color: Colors.white),
          ),
          Text(
            "Less Admin",
            style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Blackjack',
                color: Colors.white),
          ),
        ],
      ),
    );
  }

}
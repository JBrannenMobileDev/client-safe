import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: const Color(ColorConstants.primary),
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: _onAddClientPressed,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                color: const Color(ColorConstants.primary_bg_grey),
                splashColor: const Color(ColorConstants.primary_accent),
                highlightColor: const Color(ColorConstants.primary_accent),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: const Color(ColorConstants.primary_light),
                    ),
                    Text(
                      "Client",
                      style: TextStyle(color: const Color(ColorConstants.primary_light)),
                    )
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _onAddClientPressed,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                color: const Color(ColorConstants.primary_bg_grey),
                splashColor: const Color(ColorConstants.primary_accent),
                highlightColor: const Color(ColorConstants.primary_accent),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: const Color(ColorConstants.primary_light),
                    ),
                    Text(
                      "Job",
                      style: TextStyle(color: const Color(ColorConstants.primary_light)),
                    )
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _onAddClientPressed,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                color: const Color(ColorConstants.primary_bg_grey),
                splashColor: const Color(ColorConstants.primary_accent),
                highlightColor: const Color(ColorConstants.primary_accent),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: const Color(ColorConstants.primary_light),
                    ),
                    Text(
                      "Search",
                      style: TextStyle(color: const Color(ColorConstants.primary_light)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onAddClientPressed() {

  }
}

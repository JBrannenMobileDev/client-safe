import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/HostDetectionUtil.dart';
import 'package:flutter/material.dart';

class DashboardActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(ColorConstants.primary),
        image: DecorationImage(
          image: AssetImage('assets/images/flexible_space_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      padding: HostDetectionUtil.isIos(context)
          ? EdgeInsets.fromLTRB(0.0, 160.0, 0.0, 16.0)
          : EdgeInsets.fromLTRB(0.0, 145.0, 0.0, 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            onPressed: _onAddClientPressed,
            textColor: Colors.white,
            padding: HostDetectionUtil.isIos(context) ? EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0) : EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            color: const Color(ColorConstants.primary_bg_grey),
            splashColor: const Color(ColorConstants.primary_accent),
            highlightColor: const Color(ColorConstants.primary_accent),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: const Color(ColorConstants.primary),
                ),
                Text(
                  "Client",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      color: const Color(ColorConstants.primary_accent)),
                )
              ],
            ),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            onPressed: _onAddClientPressed,
            textColor: Colors.white,
            padding: HostDetectionUtil.isIos(context) ? EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0) : EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            color: const Color(ColorConstants.primary_bg_grey),
            splashColor: const Color(ColorConstants.primary_accent),
            highlightColor: const Color(ColorConstants.primary_accent),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: const Color(ColorConstants.primary),
                ),
                Text(
                  "Job",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      color: const Color(ColorConstants.primary_accent)),
                )
              ],
            ),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            onPressed: _onAddClientPressed,
            textColor: Colors.white,
            padding: HostDetectionUtil.isIos(context) ? EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0) : EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            color: const Color(ColorConstants.primary_bg_grey),
            splashColor: const Color(ColorConstants.primary_accent),
            highlightColor: const Color(ColorConstants.primary_accent),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: const Color(ColorConstants.primary),
                ),
                Text(
                  "Search",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      color: const Color(ColorConstants.primary_accent)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onAddClientPressed() {}
}

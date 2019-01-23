import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class CalendarBox extends StatelessWidget{
  CalendarBox({this.dayOfMonth, this.clientName});
  final String dayOfMonth;
  final String clientName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
          child: Text(
            dayOfMonth,
            style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                color: const Color(ColorConstants.primary_dark)),
          ),
        ),
        clientName != null ? Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(ColorConstants.primary_dark),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
            margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Text(
              clientName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ): Container(),
      ],
    );
  }

}
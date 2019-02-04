import 'package:client_safe/models/LeadListItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/Shadows.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeadListWidget extends StatelessWidget {
  LeadListWidget(this.lead);

  final LeadListItem lead;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.0,
      margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      decoration: BoxDecoration(
        color: const Color(ColorConstants.primary_bg_grey),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        boxShadow: ElevationToShadow.values.elementAt(1),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              lead.name,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
                color: const Color(ColorConstants.primary_dark),
              ),
            ),
            Text(
             lead.number,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                color: const Color(ColorConstants.primary_dark),
              ),
            ),
            Text(
              "Date added: " +
                  DateFormat('MM-dd-yyyy').format(lead.dateAdded),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                color: const Color(ColorConstants.primary_dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:client_safe/utils/Shadows.dart';

class MarketingTile extends StatelessWidget {
  MarketingTile({this.title, this.content1, this.content2});

  final String title;
  final String content1;
  final String content2;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
        height: 150.0,
        decoration: BoxDecoration(
          color: const Color(ColorConstants.primary_bg_grey),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: ElevationToShadow.values.elementAt(1),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 4.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500,
                    color: const Color(ColorConstants.primary_marketing),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              child: Text(
                "Valentine's Day",
                style: TextStyle(
                    fontSize: 36.0,
                    fontFamily: 'Blackjack',
                    fontWeight: FontWeight.w900,
                  color: const Color(ColorConstants.primary_marketing),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  color: const Color(ColorConstants.primary_marketing),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      content1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      content2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

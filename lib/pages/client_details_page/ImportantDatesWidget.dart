import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/client_details_page/ImportantDates.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../widgets/TextDandyLight.dart';

class ImportantDatesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientDetailsPageState>(
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) =>
          GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            barrierColor:
                Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
            builder: (context) {
              return ImportantDates();
            },
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 128),
          height: 104,
          decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 16),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 24.0, bottom: 8.0, right: 24),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Important Dates',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 18.0),
                    height: 38.0,
                    width: 38.0,
                    child: Image.asset(
                      'assets/images/icons/calendar_icon_peach.png',
                      color: Color(ColorConstants.peach_dark),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: pageState.client.importantDates.length == 1 ? '1 Date' : pageState.client.importantDates.length.toString() + ' Dates',
                            textAlign: TextAlign.start,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.chevron_right,
                            color: Color(
                                ColorConstants.getPrimaryBackgroundGrey()),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

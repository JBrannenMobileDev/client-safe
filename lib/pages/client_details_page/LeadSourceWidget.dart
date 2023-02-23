import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/ImageUtil.dart';
import '../../widgets/TextDandyLight.dart';
import 'LeadSourceSelectionWidget.dart';

class LeadSourceWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientDetailsPageState>(
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) =>
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
                builder: (context) {
                  return LeadSourceSelectionWidget();
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: 16, top: 0, right: 16, bottom: 16),
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
                    padding: EdgeInsets.only(
                        left: 24.0, bottom: 8.0, right: 24),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Lead Source',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: 24, right: 18.0),
                        height: 38.0,
                        width: 38.0,
                        child: Image.asset(
                          pageState.client.leadSource,
                          color: Color(ColorConstants.peach_dark),),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 4.0, top: 4.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: _getLeadSourceName(pageState),
                                textAlign: TextAlign.start,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.chevron_right,
                                color: Color(ColorConstants
                                    .getPrimaryBackgroundGrey()),
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

  String _getLeadSourceName(ClientDetailsPageState pageState) {
    return (pageState.client.customLeadSourceName != null && pageState.client.customLeadSourceName.isNotEmpty ? pageState.client.customLeadSourceName : ImageUtil.getLeadSourceText(pageState.client.leadSource));

  }
}

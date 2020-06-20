import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LeadSourceSelection extends StatefulWidget {
  @override
  _LeadSourceSelection createState() {
    return _LeadSourceSelection();
  }
}

class _LeadSourceSelection extends State<LeadSourceSelection>
    with AutomaticKeepAliveClientMixin {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> leadSourceIconsWhite = ImageUtil.leadSourceIconsWhite;
    List<String> leadSourceIconsPeach = ImageUtil.leadSourceIconsPeach;
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Text(
                "How did " +
                    pageState.newContactFirstName +
                    " hear about your business?",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 8,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.8),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      pageState.onLeadSourceSelected(leadSourceIconsWhite.elementAt(index));
                    },
                    child:
                    Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            pageState.leadSource != null && getIconPosition(pageState, leadSourceIconsWhite) == index ? new Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              height: 46.0,
                              width: 46.0,
                              decoration: new BoxDecoration(
                                color: Color(ColorConstants.getBlueLight()),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ) : SizedBox(
                              height: 54.0,
                              width: 46.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              height: 36.0,
                              width: 36.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(pageState.leadSource != null && getIconPosition(pageState, leadSourceIconsWhite) == index ? leadSourceIconsWhite.elementAt(index) : leadSourceIconsPeach.elementAt(index)),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ImageUtil.getLeadSourceText(leadSourceIconsWhite.elementAt(index)),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w400,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  int getIconPosition(NewContactPageState pageState, List<String> leadSourceIconsWhite) {
    return leadSourceIconsWhite.indexOf(pageState.leadSource);
  }
}

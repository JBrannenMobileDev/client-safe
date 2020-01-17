import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
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
    List<String> leadSourceIcons = ImageUtil.leadSourceIcons;
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8.0),
              child: Text(
                "How did " +
                    pageState.newContactFirstName +
                    " hear about your business?",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8.0),
              child: Text(
                pageState.leadSource != null ? ImageUtil.getLeadSourceText(pageState.leadSource) : "",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryColor()),
                ),
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 8,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      pageState.onLeadSourceSelected(leadSourceIcons.elementAt(index));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(leadSourceIcons.elementAt(index)),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: pageState.leadSource != null && getIconPosition(pageState, leadSourceIcons) != index ? new Container(
                        decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.5)),
                      ) : SizedBox(),
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

  int getIconPosition(NewContactPageState pageState, List<String> leadSourceIcons) {
    return leadSourceIcons.indexOf(pageState.leadSource);
  }
}

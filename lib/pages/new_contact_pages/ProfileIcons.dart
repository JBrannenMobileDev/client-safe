import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfileIcons extends StatefulWidget {
  @override
  _ProfileIcons createState() {
    return _ProfileIcons();
  }
}

class _ProfileIcons extends State<ProfileIcons>
    with AutomaticKeepAliveClientMixin {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> profileIcons = ImageUtil.femaleIcons + ImageUtil.maleIcons;
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
              margin: EdgeInsets.only(bottom: 16.0),
              child: Text(
                "Select an icon that looks most like " +
                    pageState.newContactFirstName +
                    ".",
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
                itemCount: profileIcons.length,
                physics: ClampingScrollPhysics(),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      pageState.onClientIconSelected(profileIcons.elementAt(index));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      height: 32.0,
                      width: 32.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(profileIcons.elementAt(index)),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: pageState.clientIcon != null && profileIcons.indexOf(pageState.clientIcon) != index ? new Container(
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
}

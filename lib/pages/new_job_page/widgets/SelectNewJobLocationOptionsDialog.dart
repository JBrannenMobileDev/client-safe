import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../widgets/TextDandyLight.dart';


class SelectNewJobLocationOptionsDialog extends StatefulWidget {
  @override
  _SelectNewJobLocationOptionsDialog createState() {
    return _SelectNewJobLocationOptionsDialog();
  }
}

class _SelectNewJobLocationOptionsDialog extends State<SelectNewJobLocationOptionsDialog> with AutomaticKeepAliveClientMixin {
  final locationNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        locationNameTextController.text = store.state.newLocationPageState.locationName;
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "Select a one time location from a map or add a new location to your location collection.",
                textAlign: TextAlign.center,
                color: Color(ColorConstants.primary_black),
              ),
            ),
            GestureDetector(
              onTap: () {
                UserOptionsUtil.showNewLocationDialog(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 56,
                width: 250,
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(ColorConstants.getBlueDark())
                ),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'New Saved Location',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                NavigationUtil.onSelectMapLocation(context, null, pageState.lat, pageState.lon, pageState.onLocationSearchResultSelected);
              },
              child: Container(
                alignment: Alignment.center,
                height: 56,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(ColorConstants.getBlueDark())
                ),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'New One-time Location',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
          ],
        ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

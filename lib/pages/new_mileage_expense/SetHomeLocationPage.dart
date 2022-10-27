import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SetHomeLocationPage extends StatefulWidget {
  final Function(NewMileageExpensePageState) onNextSelected;

  SetHomeLocationPage(this.onNextSelected);

  @override
  _SetHomeLocationPage createState() {
    return _SetHomeLocationPage(onNextSelected);
  }
}

class _SetHomeLocationPage extends State<SetHomeLocationPage> with AutomaticKeepAliveClientMixin {
  final Function(NewMileageExpensePageState) onNextSelected;

  _SetHomeLocationPage(this.onNextSelected);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewMileageExpensePageState>(
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 42.0, top: 16.0),
              child: Text(
                'Would you like to add your default start location?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            pageState.selectedHomeLocationName.isEmpty ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    NavigationUtil.onSelectMapLocation(context, pageState.onMapLocationSaved, pageState.lat, pageState.lng, null);
                  },
                  child: Container(
                  alignment: Alignment.center,
                  height: 96.0,
                  width: 96.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(ColorConstants.getBlueLight())
                  ),
                  child: Text(
                    'Yes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
                ),
                GestureDetector(
                  onTap: () {
                    onNextSelected(pageState);
                  },
                  child: Container(
                  alignment: Alignment.center,
                  height: 96.0,
                  width: 96.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(ColorConstants.getPeachDark())
                  ),
                  child: Text(
                    'No',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
                ),
              ],
            ) : GestureDetector(
              onTap: () {
                NavigationUtil.onSelectMapLocation(context, pageState.onMapLocationSaved, pageState.lat, pageState.lng, null);
              },
              child: Container(
                alignment: Alignment.center,
                height: 64.0,
                width: 250.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Color(ColorConstants.getPeachDark())
                ),
                child: Text(
                  pageState.selectedHomeLocationName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
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

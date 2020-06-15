import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SetHomeLocationPage extends StatefulWidget {
  @override
  _SetHomeLocationPage createState() {
    return _SetHomeLocationPage();
  }
}

class _SetHomeLocationPage extends State<SetHomeLocationPage> with AutomaticKeepAliveClientMixin {

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
              padding: EdgeInsets.only(bottom: 56.0, top: 16.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    NavigationUtil.onAddStartLocationSelected(context);
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
                    UserOptionsUtil.showNewMileageExpenseSelected(context);
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

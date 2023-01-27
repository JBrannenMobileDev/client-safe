import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class SelectStartEndLocationsPage extends StatefulWidget {
  static const String FILTER_TYPE_ONE_WAY = "One Way";
  static const String FILTER_TYPE_ROUND_TRIP = "Round Trip";
  
  @override
  _SelectStartEndLocationsPage createState() {
    return _SelectStartEndLocationsPage();
  }
}

class _SelectStartEndLocationsPage extends State<SelectStartEndLocationsPage> with AutomaticKeepAliveClientMixin {
  int selectedIndex = 1;
  Map<int, Widget> tabs;
  
  @override
  Widget build(BuildContext context) {
    tabs = <int, Widget>{
      0: Text(SelectStartEndLocationsPage.FILTER_TYPE_ONE_WAY, style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'simple',
        fontWeight: FontWeight.w400,
        color: Color(selectedIndex == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
      ),),
      1: Text(SelectStartEndLocationsPage.FILTER_TYPE_ROUND_TRIP, style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'simple',
        fontWeight: FontWeight.w400,
        color: Color(selectedIndex == 1 ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
      ),),
    };
    super.build(context);
    return StoreConnector<AppState, NewMileageExpensePageState>(
      onInit: (appState) {
        selectedIndex = appState.state.newMileageExpensePageState.isOneWay ? 0 : 1;
      },
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Text(
                'Select the start and end locations for this mileage trip.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0, top: 16.0),
              child: Text(
                'Start location:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                UserOptionsUtil.showMileageLocationSelectionDialog(
                    context,
                    pageState.onStartLocationChanged,
                    pageState.profile.hasDefaultHome() ? pageState.profile.latDefaultHome : pageState.startLocation != null ? pageState.startLocation.latitude : pageState.lat,
                    pageState.profile.hasDefaultHome() ? pageState.profile.lngDefaultHome : pageState.startLocation != null ? pageState.startLocation.longitude : pageState.lng
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 48.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Color(ColorConstants.getPeachDark())
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 16.0),
                      height: 26.0,
                      width: 26.0,
                      child: Image.asset('assets/images/icons/location_icon_white.png'),
                    ),
                    Container(
                      child: Text(
                        pageState.startLocationName.isNotEmpty ? pageState.startLocationName : pageState.selectedHomeLocationName.isNotEmpty ? pageState.selectedHomeLocationName : 'Select a location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0, top: 16.0),
              child: Text(
                'End location:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                UserOptionsUtil.showMileageLocationSelectionDialog(
                    context,
                    pageState.onEndLocationChanged,
                    pageState.profile.hasDefaultHome() ? pageState.profile.latDefaultHome : pageState.startLocation != null ? pageState.startLocation.latitude : pageState.lat,
                    pageState.profile.hasDefaultHome() ? pageState.profile.lngDefaultHome : pageState.startLocation != null ? pageState.startLocation.longitude : pageState.lng
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 48.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Color(ColorConstants.getPeachDark())
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 16.0),
                      height: 26.0,
                      width: 26.0,
                      child: Image.asset('assets/images/icons/location_icon_white.png'),
                    ),
                    Container(
                      child: Text(
                        pageState.endLocationName.isEmpty ? 'Select a location' : pageState.endLocationName,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 300.0,
              margin: EdgeInsets.only(top: 32.0),
              child: CupertinoSlidingSegmentedControl<int>(
                thumbColor: Color(ColorConstants.getBlueDark()),
                backgroundColor: Colors.transparent,
                children: tabs,
                onValueChanged: (int filterTypeIndex) {
                  setState(() {
                    selectedIndex = filterTypeIndex;
                  });
                  pageState.onFilterChanged(filterTypeIndex == 0 ? SelectStartEndLocationsPage.FILTER_TYPE_ONE_WAY : SelectStartEndLocationsPage.FILTER_TYPE_ROUND_TRIP);
                },
                groupValue: selectedIndex,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Text(
                        'Miles driven',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextDandyLight(
                            type: TextDandyLight.EXTRA_LARGE_TEXT,
                            amount: pageState.isOneWay ? pageState.milesDrivenOneWay : pageState.milesDrivenRoundTrip,
                            color: Color(ColorConstants.getPrimaryBlack()),
                            isCurrency: false,
                            decimalPlaces: 1,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              'mi',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Text(
                        'Potential deduction',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                      child: TextDandyLight(
                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                        amount: pageState.expenseCost,
                        color: Color(ColorConstants.getPrimaryBlack()),
                        isCurrency: true,
                      ),
                    ),
                  ],
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

import 'dart:async';
import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class MileageLocationListWidget extends StatelessWidget {
  final int locationIndex;

  MileageLocationListWidget(this.locationIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewMileageExpensePageState>(
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) => Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: 200,
                width: 150,
                margin: EdgeInsets.only(top: 8.0),
                child: pageState.locations.elementAt(locationIndex) != null ?
                Container(
                    height: 200,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(16.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: pageState.imageFiles.isNotEmpty
                            ? FileImage(pageState.imageFiles.elementAt(locationIndex))
                            : AssetImage("assets/images/backgrounds/image_background.png"),
                      ),
                    )
                )
                    : SizedBox(),
              ),
              pageState.selectedLocation != pageState.locations.elementAt(locationIndex)
                  ? Container(
                height: 200,
                width: 150,
                      margin:
                          EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryBlack()),
                          borderRadius: new BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                              begin: FractionalOffset.center,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                    )
                  : Container(
                height: 200,
                width: 150,
                      margin:
                          EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryBlack()),
                          borderRadius: new BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                              begin: FractionalOffset.center,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Color(ColorConstants.getPeachDark()).withOpacity(0.5),
                                Color(ColorConstants.getPeachDark()).withOpacity(0.5),
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                    ),
              Container(
                height: 200,
                width: 150,
                child: GestureDetector(
                  onTap: () async {
                    pageState.onLocationSelected(pageState.locations.elementAt(locationIndex));
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 4.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.locations.elementAt(locationIndex).locationName,
                textAlign: TextAlign.center,
                color: pageState.selectedLocation != pageState.locations.elementAt(locationIndex)
                    ? Color(ColorConstants.getPrimaryBlack())
                    : Color(ColorConstants.getPeachDark()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class JobDetailsLocationListWidget extends StatelessWidget {
  final int locationIndex;

  JobDetailsLocationListWidget(this.locationIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) => Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: _getItemWidthHeight(context) - (_getItemWidthHeight(context) * 0.33),
                margin: EdgeInsets.only(top: 8.0),
                child: pageState.locations.elementAt(locationIndex) != null ?
                Container(
                    height: _getItemWidthHeight(context) - (_getItemWidthHeight(context) * 0.33),
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
              pageState.selectedLocation == null || pageState.selectedLocation.documentId != pageState.locations.elementAt(locationIndex).documentId
                  ? Container(
                      height: _getItemWidthHeight(context) - (_getItemWidthHeight(context) * 0.33),
                      margin:
                          EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.primary_black),
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
                      height: _getItemWidthHeight(context) - (_getItemWidthHeight(context) * 0.33),
                      margin:
                          EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.primary_black),
                          borderRadius: new BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                              begin: FractionalOffset.center,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Color(ColorConstants.getPrimaryColor()).withOpacity(0.5),
                                Color(ColorConstants.getPrimaryColor()).withOpacity(0.5),
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                    ),
              Container(
                height: _getItemWidthHeight(context) - (_getItemWidthHeight(context) * 0.33),
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () async {
                    pageState.onLocationSelected(
                        pageState.locations.elementAt(locationIndex));
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
                    ? const Color(ColorConstants.primary_black)
                    : Color(ColorConstants.getPrimaryColor()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getItemWidthHeight(BuildContext context){
    return (MediaQuery.of(context).size.width/2);
  }
}

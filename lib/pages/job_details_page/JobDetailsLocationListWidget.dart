import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/DandyLightNetworkImage.dart';
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
              pageState.locations.elementAt(locationIndex) != null ?
              Container(
                height: 187,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(16.0),
                    color: Color(ColorConstants.getPeachLight())
                  ),
                child: DandyLightNetworkImage(
                  pageState.locations.elementAt(locationIndex).imageUrl
                ),
              ) : SizedBox(),
              Container(
                height: 187,
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () async {
                    pageState.onLocationSelected(pageState.locations.elementAt(locationIndex));
                    pageState.onLocationSaveSelected(pageState.locations.elementAt(locationIndex));
                    Navigator.of(context).pop();
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
                maxLines: 2,
                textAlign: TextAlign.center,
                color: Color(ColorConstants.getPrimaryBlack()),
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

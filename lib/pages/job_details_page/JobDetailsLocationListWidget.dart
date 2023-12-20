import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';

class JobDetailsLocationListWidget extends StatelessWidget {
  final int locationIndex;

  const JobDetailsLocationListWidget(this.locationIndex, {Key key}) : super(key: key);

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
                height: _getItemWidthHeight(context),
                margin: const EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getBlueDark()),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Color(ColorConstants.getPeachDark()),
                      width: pageState.selectedLocation == pageState.locations.elementAt(locationIndex) ? 3 : 0,
                    )
                ),
                child: DandyLightNetworkImage(pageState.locations.elementAt(locationIndex).imageUrl),
              ),
              pageState.selectedLocation == pageState.locations.elementAt(locationIndex)
                  ? Container(
                height: _getItemWidthHeight(context) + 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Stack(
                      children: [
                        Icon(
                          Device.get().isIos ? CupertinoIcons.circle_fill : Icons.circle,
                          size: 26.0,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                        Icon(
                          Device.get().isIos ? CupertinoIcons.check_mark_circled_solid : Icons.check_circle,
                          size: 26.0,
                          color: Color(ColorConstants.getPeachDark()),
                        )
                      ],
                    ),
                  ),
                ),
              ) : const SizedBox(),
              SizedBox(
                height: _getItemWidthHeight(context) + 3,
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
              margin: const EdgeInsets.only(top: 4.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.locations.elementAt(locationIndex).locationName,
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

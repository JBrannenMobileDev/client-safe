import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../widgets/DandyLightNetworkImage.dart';
import '../../../widgets/TextDandyLight.dart';

class JobLocationListWidget extends StatelessWidget {
  final int locationIndex;

  const JobLocationListWidget(this.locationIndex, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          pageState.locations.isNotEmpty
              ? Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 28.0),
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPeachLight()),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DandyLightNetworkImage(
              pageState.locations.elementAt(locationIndex).imageUrl,
              errorType:
              pageState.locations.elementAt(locationIndex).imageUrl !=
                  null &&
                  pageState.locations
                      .elementAt(locationIndex)
                      .imageUrl
                      .isNotEmpty
                  ? DandyLightNetworkImage.ERROR_TYPE_INTERNET
                  : DandyLightNetworkImage.ERROR_TYPE_NO_IMAGE,
              errorIconSize: pageState.locations.elementAt(locationIndex).imageUrl != null && pageState.locations.elementAt(locationIndex).imageUrl.isNotEmpty ? 44 : 96,
            ),
          )
              : const SizedBox(),
          TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            text: pageState.locations.elementAt(locationIndex).locationName,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          pageState.selectedLocation == pageState.locations.elementAt(locationIndex)
              ? Container(
            margin: const EdgeInsets.only(bottom: 28.0),
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Device.get().isIos
                        ? CupertinoIcons.circle_fill
                        : Icons.circle,
                    size: 64.0,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                  Icon(
                    Device.get().isIos
                        ? CupertinoIcons.check_mark_circled_solid
                        : Icons.check_circle,
                    size: 64.0,
                    color: Color(ColorConstants.getPeachDark()),
                  )
                ],
              ),
            ),
          )
              : const SizedBox(),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () async {
                pageState.onLocationSelected(pageState.locations.elementAt(locationIndex));
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getItemWidthHeight(BuildContext context){
    return (MediaQuery.of(context).size.width/2) - 3;
  }
}

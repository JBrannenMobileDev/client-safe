import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../widgets/TextDandyLight.dart';

class JobLocationListWidget extends StatelessWidget {
  final int locationIndex;

  const JobLocationListWidget(this.locationIndex, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: _getItemWidthHeight(context),
                margin: const EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: pageState.imageFiles.isNotEmpty && pageState.imageFiles.length > locationIndex && pageState.imageFiles.elementAt(locationIndex) != null
                          ?  FileImage(pageState.imageFiles.elementAt(locationIndex))
                          : const AssetImage("assets/images/backgrounds/image_background.png")
                  ),
                  color: Color(ColorConstants.getBlueDark()),
                  borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Color(ColorConstants.getPeachDark()),
                      width: pageState.selectedLocation == pageState.locations.elementAt(locationIndex) ? 3 : 0,
                    )
                ),
              ),
              pageState.imageFiles.isNotEmpty && pageState.imageFiles.length > locationIndex && pageState.imageFiles.elementAt(locationIndex) != null && pageState.imageFiles.elementAt(locationIndex).path.isEmpty ?
                Container(
                  margin: const EdgeInsets.only(bottom: 54.0),
                  height: 96.0,
                  width: 96.0,
                  child: Image.asset('assets/images/icons/location_icon_white.png'),
                ) : const SizedBox(),
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
                    pageState.onLocationSelected(
                        pageState.locations.elementAt(locationIndex));
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
    return (MediaQuery.of(context).size.width/2) - 3;
  }
}

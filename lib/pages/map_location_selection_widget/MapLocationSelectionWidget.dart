import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidgetState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';

import '../../models/Location.dart';
import '../../utils/Shadows.dart';
import '../../widgets/TextDandyLight.dart';

class MapLocationSelectionWidget extends StatefulWidget {
  final Function(LatLng) onMapLocationSaved;
  final Function(Location) saveSelectedLocation;
  final double lat;
  final double lng;

  MapLocationSelectionWidget(this.onMapLocationSaved, this.lat, this.lng, this.saveSelectedLocation);

  @override
  State<StatefulWidget> createState() {
    return _MapLocationSelectionWidgetState(onMapLocationSaved, lat, lng, saveSelectedLocation);
  }
}


class _MapLocationSelectionWidgetState extends State<MapLocationSelectionWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController controller = TextEditingController();
  Timer _throttle;
  final FocusNode _searchFocus = FocusNode();

  final Function(LatLng) onMapLocationSaved;
  final Function(Location) saveSelectedLocation;

  final double lat;
  final double lng;

  _MapLocationSelectionWidgetState(this.onMapLocationSaved, this.lat, this.lng, this.saveSelectedLocation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> animateTo(double lat, double lng) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 15);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MapLocationSelectionWidgetState>(
      onWillChange: (pageStatePrevious, pageState) async {
        controller.value = controller.value.copyWith(text: pageState.searchText);
        if(pageState.selectedSearchLocation != null && pageStatePrevious.locationResults.length > 0){
          animateTo(pageState.selectedSearchLocation.latitude, pageState.selectedSearchLocation.longitude);
        }
      },
      converter: (Store<AppState> store) => MapLocationSelectionWidgetState.fromStore(store),
      builder: (BuildContext context, MapLocationSelectionWidgetState pageState) =>
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(ColorConstants.getBlueDark()),
            body: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat, lng),
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    compassEnabled: false,
                    onCameraIdle: () async{
                      final GoogleMapController controller = await _controller.future;
                      LatLng latLng = await controller.getLatLng(
                          ScreenCoordinate(
                            x: (MediaQuery.of(context).size.width/2).round(),
                            y: (MediaQuery.of(context).size.height/2).round(),
                          )
                      );
                      pageState.onMapLocationChanged(latLng);
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 36.0),
                    alignment: Alignment.center,
                    height: 48.0,
                    width: 48.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageUtil.locationPin),
                        fit: BoxFit.contain,
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                ),
            SafeArea(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 14.0),
                child: GestureDetector(
                  onTap: () {
                    if(onMapLocationSaved != null) onMapLocationSaved(LatLng(pageState.lat, pageState.lng));
                    if(saveSelectedLocation != null) {
                      if(pageState.selectedSearchLocation != null) {
                        saveSelectedLocation(pageState.selectedSearchLocation);
                      }else {
                        saveSelectedLocation(Location(
                            latitude: pageState.lat,
                            longitude: pageState.lng,
                          locationName: 'One-Time Location'
                        ));
                      }
                    }
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: ElevationToShadow[2],
                        borderRadius: BorderRadius.circular(26.0),
                        color: Color(ColorConstants.getPrimaryColor())),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Save',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 250.0,
                  height: 50.0,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16.0),
                  decoration: BoxDecoration(
                      boxShadow: ElevationToShadow[2],
                      borderRadius: BorderRadius.circular(26.0),
                      color: Color(ColorConstants.getPrimaryWhite())
                  ),
                  child: TextFormField(
                      controller: controller,
                      focusNode: _searchFocus,
                      onChanged: (text) {
                        if(_throttle?.isActive ?? false) {
                          _throttle.cancel();
                        } else {
                          _throttle = Timer(const Duration(milliseconds: 350), () {
                            pageState.onThrottleGetLocations(text);
                          });
                        }
                        pageState.onSearchInputChanged(text);
                      },
                      onEditingComplete: () {
                        _searchFocus.unfocus();
                      },
                      onFieldSubmitted: (text) {
                        _searchFocus.unfocus();
                      },
                      onSaved: (text) {
                        _searchFocus.unfocus();
                      },
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: 'Search',
                      ),
                    ),
                  ),
                ),
              ),
              pageState.locationResults.length > 0 ? SafeArea(
                child: Container(
                  height: 350.0,
                  margin: EdgeInsets.only(top: 64.0, left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                    boxShadow: ElevationToShadow[2],
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.locationResults.length,
                    itemBuilder: (context, index) {
                      return TextButton(
                        style: Styles.getButtonStyle(),
                        onPressed: () {
                          pageState.onSearchLocationSelected(pageState.locationResults.elementAt(index));
                          _searchFocus.unfocus();
                        },
                        child: Container(
                          height: 64.0,
                          margin: EdgeInsets.only(top: index == 0 ? 16.0 : 0.0),
                          padding: EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 16.0, top: 4.0),
                                height: 32.0,
                                width: 32.0,
                                child: Image.asset('assets/images/collection_icons/location_pin_blue.png'),
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: TextDandyLight(
                                        type: TextDandyLight.SMALL_TEXT,
                                        text: pageState.locationResults.elementAt(index).name,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.visible,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextDandyLight(
                                        type: TextDandyLight.SMALL_TEXT,
                                        text: pageState.locationResults.elementAt(index).address,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.visible,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ) : SizedBox(),
                SafeArea(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 8.0),
                      padding: EdgeInsets.only(left: 8.0),
                      alignment: Alignment.topLeft,
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: ElevationToShadow[2],
                          color: Color(ColorConstants.getPrimaryWhite())
                      ),
                      child: IconButton(
                        icon: Icon(Device.get().isIos ? Icons.arrow_back_ios : Icons.arrow_back),
                        tooltip: 'Back',
                        color: Color(ColorConstants.primary_black),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ),
                  ),
                ),
                _searchFocus.hasFocus ? SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(right: 16.0),
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: ElevationToShadow[2],
                          color: Color(ColorConstants.getPrimaryWhite())
                      ),
                      child: Container(
                        alignment: Alignment.center,

                        child: IconButton(
                          iconSize: 32.0,
                          icon: const Icon(Icons.close),
                          tooltip: 'Delete',
                          color: Color(ColorConstants.getPrimaryColor()),
                          onPressed: () {
                            _searchFocus.unfocus();
                            pageState.onClearSearchTextSelected();
                          },
                        ),
                      ),
                    ),
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
    );
  }
}

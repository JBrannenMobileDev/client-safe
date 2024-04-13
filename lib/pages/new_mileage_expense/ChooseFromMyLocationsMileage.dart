import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_mileage_expense/MileageLocationListWidget.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/TextDandyLight.dart';


class ChooseFromMyLocationsMileage extends StatefulWidget {
  final Function(LatLng) onLocationSaved;

  const ChooseFromMyLocationsMileage(this.onLocationSaved, {Key? key}) : super(key: key);

  @override
  _ChooseFromMyLocationsMileageState createState() {
    return _ChooseFromMyLocationsMileageState(onLocationSaved);
  }
}

class _ChooseFromMyLocationsMileageState extends State<ChooseFromMyLocationsMileage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Function(LatLng) onLocationSaved;

  _ChooseFromMyLocationsMileageState(this.onLocationSaved);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewMileageExpensePageState>(
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              alignment: Alignment.center,
              child: pageState.locations!.isNotEmpty
                  ? Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 0.0),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: "Select a Location",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: pageState.selectedLocation != null
                          ? pageState.selectedLocation!.locationName
                          : "",
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPeachDark()),
                    ),
                  ),
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 65.0,
                        maxHeight: MediaQuery.of(context).size.height - 232,
                      ),
                      child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 64.0),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 2.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16),
                          itemCount: pageState.locations!.length,
                          controller: _controller,
                          physics: const ClampingScrollPhysics(),
                          key: _listKey,
                          shrinkWrap: true,
                          reverse: false,
                          itemBuilder: _buildItem)
                  ),
                ],
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "Select a location",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0, top: 16.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "You do not have any locations saved to your collection.",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(
                      color: Color(ColorConstants.getPrimaryColor()),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: () {
                      UserOptionsUtil.showNewLocationDialog(context);
                    },
                    child: SizedBox(
                      width: 150.0,
                      child: Row(

                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.add),
                            color: const Color(ColorConstants.white),
                            tooltip: 'Add',
                            onPressed: () {
                              UserOptionsUtil.showNewPriceProfileDialog(context);
                            },
                          ),
                          TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: "Location",
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26.0, right: 26.0, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    style: Styles.getButtonStyle(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      textColor: Color(ColorConstants.getPrimaryBlack()),
                      left: 8.0,
                      top: 8.0,
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                    // disabledTextColor:
                    // Color(ColorConstants.primary_bg_grey),
                    // splashColor: Color(ColorConstants.getPrimaryColor()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Cancel',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      textColor: Color(ColorConstants.getPrimaryBlack()),
                      left: 8.0,
                      top: 8.0,
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                    // disabledTextColor:
                    // Color(ColorConstants.primary_bg_grey),
                    // splashColor: Color(ColorConstants.getPrimaryColor()),
                    onPressed: () {
                      if(pageState.selectedLocation != null){
                        onLocationSaved(LatLng(pageState.selectedLocation!.latitude!, pageState.selectedLocation!.longitude!));
                        Navigator.of(context).pop();
                      }
                    },
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Save',
                      textAlign: TextAlign.start,
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
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewMileageExpensePageState>(
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) => Container(
        margin: const EdgeInsets.only(top: 0.0, bottom: 8.0),
        child: JobLocationListWidget(index),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

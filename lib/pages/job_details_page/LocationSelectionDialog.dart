import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsLocationListWidget.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/JobLocationListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LocationSelectionDialog extends StatefulWidget {
  @override
  _LocationSelectionDialogState createState() {
    return _LocationSelectionDialogState();
  }
}

class _LocationSelectionDialogState
    extends State<LocationSelectionDialog> {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              height: 550.0,
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: pageState.locations.length > 0
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
                    child: Text(
                      "Select a location for this job.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w800,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      pageState.selectedLocation != null
                          ? pageState.selectedLocation.locationName
                          : "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryColor()),
                      ),
                    ),
                  ),
                  Container(
                    height: 400.0,
                    child: ListView.builder(
                      reverse: false,
                      padding: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 64.0),
                      shrinkWrap: true,
                      controller: _controller,
                      physics: ClampingScrollPhysics(),
                      key: _listKey,
                      itemCount: pageState.locations.length,
                      itemBuilder: _buildItem,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            pageState.onLocationSaveSelected(pageState.selectedLocation);
                            VibrateUtil.vibrateHeavy();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0, top: 64.0),
                    child: Text(
                      "Select a location for this job",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w800,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 64.0, top: 32.0),
                    child: Text(
                      "A location will store the name and map coordinates for a location that you regularly use. "
                          "Select the button below to create a new location.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  ClientSafeButton(
                    height: 64.0,
                    width: 150.0,
                    text: "Location",
                    marginLeft: 32.0,
                    marginTop: 0.0,
                    marginRight: 32.0,
                    marginBottom: 0.0,
                    onPressed: () {
                      UserOptionsUtil.showNewLocationDialog(context);
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    urlText: "",
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) => Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: JobDetailsLocationListWidget(index),
      ),
    );
  }
}

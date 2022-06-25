import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/JobLocationListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LocationSelectionForm extends StatefulWidget {
  @override
  _LocationSelectionFormState createState() {
    return _LocationSelectionFormState();
  }
}

class _LocationSelectionFormState
    extends State<LocationSelectionForm>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        child: pageState.locations.length > 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Select a location for this job.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 65.0,
                      maxHeight: 400.0,
                    ),
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
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0, top: 8.0),
                    child: Text(
                      "Select a location for this job",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0, top: 16.0),
                    child: Text(
                      "You do ot have any locations saved to your collection. Select the + Location button to create a new location.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(
                      color: Color(ColorConstants.getPrimaryColor()),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: () {
                      UserOptionsUtil.showNewLocationDialog(context);
                    },
                    child: Container(
                      width: 150.0,
                      child: Row(

                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.add),
                            color: Color(ColorConstants.white),
                            tooltip: 'Add',
                            onPressed: () {
                              UserOptionsUtil.showNewPriceProfileDialog(context);
                            },
                          ),
                          Text(
                            "Location",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: JobLocationListWidget(index),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

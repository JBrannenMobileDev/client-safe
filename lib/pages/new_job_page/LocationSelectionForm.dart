import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/common_widgets/ClientSafeButton.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/JobLocationListWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
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
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        child: pageState.locations.length > 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Select a location for this job.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Raleway',
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
                        fontSize: 18.0,
                        fontFamily: 'Raleway',
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
                      "Select a locaiton for this job",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      "A location will store the name and map coordinates for a location that you regularly use. "
                      "Driving directions can be started and shared from a location."
                      "Select the button below to create a new location.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  ClientSafeButton(
                    height: 64.0,
                    width: double.infinity,
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

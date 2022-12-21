import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/JobLocationListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/NavigationUtil.dart';

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
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
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
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Text(pageState.selectedLocation != null ? pageState.selectedLocation.locationName : pageState.oneTimeLocation != null ? pageState.oneTimeLocation.locationName : "",
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
                      maxHeight: 435.0,
                    ),
                    child: GridView.builder(
                            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 64.0),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 2 / 2.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16),
                            itemCount: pageState.locations.length,
                            controller: _controller,
                            physics: ClampingScrollPhysics(),
                            key: _listKey,
                            shrinkWrap: true,
                            reverse: false,
                            itemBuilder: _buildItem)
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
                      "You don't have any locations saved to your collection. Select the + icon to create a new location.",
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
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(top: 0.0, bottom: 8.0),
        child: JobLocationListWidget(index),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

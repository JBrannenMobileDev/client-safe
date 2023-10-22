import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsLocationListWidget.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

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
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: pageState.locations.length > 0
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0, top: 32.0),
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: "Select a location for this job",
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            UserOptionsUtil.showNewLocationDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 14, right: 8),
                            alignment: Alignment.centerRight,
                            height: 38.0,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPrimaryBlack()),),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Container(
                        child: GridView.builder(
                            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 250.0),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 2 / 2.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16),
                            itemCount: pageState.locations.length,
                            controller: _controller,
                            physics: AlwaysScrollableScrollPhysics(),
                            key: _listKey,
                            shrinkWrap: true,
                            reverse: false,
                            itemBuilder: _buildItem),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Cancel',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
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
                      padding: EdgeInsets.only(bottom: 24.0, top: 32.0),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Select a location for this job",
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0, top: 0.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: "Select the button below to create a new location.",
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    ClientSafeButton(
                        height: 54.0,
                        width: 150.0,
                        text: "Location",
                        marginLeft: 32.0,
                        marginTop: 0.0,
                        marginRight: 32.0,
                        marginBottom: 0.0,
                        onPressed: () {
                          UserOptionsUtil.showNewLocationDialog(context);
                        },
                        icon: Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite())),
                        urlText: "",
                        color: ColorConstants.getBlueDark()
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Cancel',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

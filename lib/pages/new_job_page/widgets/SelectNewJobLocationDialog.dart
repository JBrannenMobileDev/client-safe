
import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/widgets/SelectNewJobLocationOptionsDialog.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../widgets/TextDandyLight.dart';

class SelectNewJobLocationDialog extends StatefulWidget {
  @override
  _SelectNewJobLocationDialog createState() {
    return _SelectNewJobLocationDialog();
  }
}

class _SelectNewJobLocationDialog extends State<SelectNewJobLocationDialog> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewLocationPageState>(
      converter: (store) => NewLocationPageState.fromStore(store),
      builder: (BuildContext context, NewLocationPageState pageState) =>
          Dialog(
            insetPadding: EdgeInsets.only(left: 16.0, right: 16.0),
                backgroundColor: Colors.transparent,
                child: Container(

                  padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
                  decoration: new BoxDecoration(
                      color: Color(ColorConstants.white),
                      borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                            text: "New Location",
                            textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        height: 225.0,
                        child: SelectNewJobLocationOptionsDialog(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 26.0, right: 26.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Cancel',
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
              ),
    );
  }
}

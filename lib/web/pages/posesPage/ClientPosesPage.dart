import 'package:dandylight/AppState.dart';
import 'package:dandylight/web/pages/posesPage/StackedGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../utils/DeviceType.dart';
import '../../../widgets/TextDandyLight.dart';
import '../ClientPortalPageState.dart';
import 'package:redux/redux.dart';

class ClientPosesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClientPosesPageState();
  }
}

class _ClientPosesPageState extends State<ClientPosesPage> {

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientPortalPageState>(
        converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
        builder: (BuildContext context, ClientPortalPageState pageState) =>
        ConstrainedBox(
            constraints: BoxConstraints(minHeight: 1080),
            child: Container(
              padding: EdgeInsets.only(bottom: 32),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 32, bottom: 48),
                    child: TextDandyLight(
                      type: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight.EXTRA_LARGE_TEXT : TextDandyLight.LARGE_TEXT,
                      fontFamily: pageState.profile.selectedFontTheme!.mainFont,
                      text: 'Poses',
                    ),
                  ),
                  StackedGrid(poses: pageState.job.poses!),
                ],
              ),
            ),
        )
      );
}

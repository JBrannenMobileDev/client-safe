import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../../utils/ColorConstants.dart';
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
        converter: (Store<AppState> store) =>
            ClientPortalPageState.fromStore(store),
        builder: (BuildContext context, ClientPortalPageState pageState) =>
            Container(
              alignment: Alignment.topCenter,
              width: 1080,
              color: Color(ColorConstants.getPrimaryWhite()),
              child: Image.network(pageState.proposal.job.poses
                  .elementAt(0)
                  .imageUrl),
            ),
      );

}

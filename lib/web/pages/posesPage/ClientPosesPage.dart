import 'package:dandylight/AppState.dart';
import 'package:dandylight/web/pages/posesPage/StackedGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
        Container(
          padding: EdgeInsets.only(bottom: 32),
          child: StackedGrid(poses: pageState.proposal.job.poses),
        )
      );
}

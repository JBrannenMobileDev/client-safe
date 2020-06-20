import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'NewContactTextField.dart';

class DeviceContactsPage extends StatefulWidget {
  @override
  _DeviceContactsPageState createState() {
    return _DeviceContactsPageState();
  }
}

class _DeviceContactsPageState extends State<DeviceContactsPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: ListView.builder(
          reverse: false,
          padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
          shrinkWrap: true,
          controller: _controller,
          physics: ClampingScrollPhysics(),
          itemCount: null,
          itemBuilder: _buildItem,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, NewContactPageState>(
    converter: (store) => NewContactPageState.fromStore(store),
    builder: (BuildContext context, NewContactPageState pageState) =>
        SizedBox(),
  );
}

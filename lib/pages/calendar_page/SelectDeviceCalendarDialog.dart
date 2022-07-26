import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import 'CalendarPageState.dart';

class SelectDeviceCalendarDialog extends StatefulWidget {
  @override
  _SelectDeviceCalendarDialog createState() {
    return _SelectDeviceCalendarDialog();
  }
}

class _SelectDeviceCalendarDialog extends State<SelectDeviceCalendarDialog> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalendarPageState>(
        converter: (store) => CalendarPageState.fromStore(store),
    builder: (BuildContext context, CalendarPageState pageState) =>
      Dialog(
        child: SizedBox(height: 300.0,)
      ),
    );
  }
}
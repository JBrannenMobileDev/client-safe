import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class NewContactDeviceContactListWidget extends StatelessWidget {
  final int clientIndex;

  NewContactDeviceContactListWidget(this.clientIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
      TextButton(
        style: Styles.getButtonStyle(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
          color: pageState.filteredDeviceContacts.elementAt(clientIndex).identifier == pageState.selectedDeviceContact?.identifier ? Color(ColorConstants.getPrimaryColor()) : Colors.transparent,
        ),
        onPressed: () {
          pageState.onDeviceContactSelected(pageState.filteredDeviceContacts.elementAt(clientIndex));
        },
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Device.get().isIos ? Icon(CupertinoIcons.profile_circled) : Icon(Icons.account_circle),
              tooltip: 'Person',
              onPressed: null,
            ),
            Expanded(
              child: Container(
                height: 64.0,
                margin: EdgeInsets.only(right: 32.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextDandyLight(
                        type: TextDandyLight.EXTRA_SMALL_TEXT,
                        text: pageState.filteredDeviceContacts.elementAt(clientIndex).displayName?? 'Name not available',
                        textAlign: TextAlign.start,
                        color: pageState.filteredDeviceContacts.elementAt(clientIndex).identifier == pageState.selectedDeviceContact?.identifier ? Color(ColorConstants.getPrimaryWhite()) : Color(ColorConstants.primary_black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

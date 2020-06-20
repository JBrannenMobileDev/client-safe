import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewContactDeviceContactListWidget extends StatelessWidget {
  final int clientIndex;

  NewContactDeviceContactListWidget(this.clientIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          new FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
            ),
            color: pageState.filteredDeviceContacts.elementAt(clientIndex).identifier == pageState.selectedDeviceContact?.identifier ? Color(ColorConstants.getPrimaryColor()) : Colors.transparent,
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
                      Text(
                        pageState.filteredDeviceContacts.elementAt(clientIndex).displayName?? 'Name not available',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: pageState.filteredDeviceContacts.elementAt(clientIndex).identifier == pageState.selectedDeviceContact?.identifier ? Colors.white : Color(ColorConstants.primary_black),
                        ),
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

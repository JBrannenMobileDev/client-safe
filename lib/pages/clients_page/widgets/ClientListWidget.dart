import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPage.dart';
import 'package:dandylight/pages/clients_page/ClientsPage.dart';
import 'package:dandylight/pages/clients_page/ClientsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../utils/styles/Styles.dart';
import '../../../widgets/TextDandyLight.dart';

class ClientListWidget extends StatelessWidget {
  final int clientIndex;

  ClientListWidget(this.clientIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientsPageState>(
      converter: (store) => ClientsPageState.fromStore(store),
      builder: (BuildContext context, ClientsPageState pageState) =>
          new TextButton(
            style: Styles.getButtonStyle(),
        onPressed: () {
          _onClientTapped(
              getClient(clientIndex, pageState), pageState, context);
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 4.0),
              height: 44.0,
              width: 44.0,
              child: Image.asset('assets/images/icons/profile_icon.png', color: Color(ColorConstants.getPrimaryColor()),),
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
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: getClient(clientIndex, pageState).getClientFullName(),
                        textAlign: TextAlign.start,
                        color: const Color(ColorConstants.primary_black),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: _buildSubtitleText(pageState, clientIndex),
                        textAlign: TextAlign.start,
                        color: const Color(ColorConstants.primary_bg_grey_dark),
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

  Client getClient(int index, ClientsPageState pageState) {
    return pageState.filterType == ClientsPage.FILTER_TYPE_ALL
        ? pageState.all.elementAt(index)
        : pageState.filterType == ClientsPage.FILTER_TYPE_CLIENTS
            ? pageState.clients.elementAt(index)
            : pageState.leads.elementAt(index);
  }

  String _buildSubtitleText(ClientsPageState pageState, int clientIndex) {
    Client client = getClient(clientIndex, pageState);
    String textToDisplay = "";
    if (client.jobs?.length ?? 0 > 0) {
    } else {
      textToDisplay = "Lead source:  " + (client.customLeadSourceName != null && client.customLeadSourceName.isNotEmpty ? client.customLeadSourceName : ImageUtil.getLeadSourceText(client.leadSource));
    }
    return textToDisplay;
  }

  _onClientTapped(Client selectedClient, ClientsPageState pageState, BuildContext context) {
    pageState.onClientClicked(selectedClient);
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) => ClientDetailsPage()),
    );
  }
}

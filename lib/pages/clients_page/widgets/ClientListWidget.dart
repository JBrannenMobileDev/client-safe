import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/clients_page/ClientsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/Shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ClientListWidget extends StatelessWidget {
  final int clientIndex;

  ClientListWidget(this.clientIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientsPageState>(
      converter: (store) => ClientsPageState.fromStore(store),
      builder: (BuildContext context, ClientsPageState pageState) =>
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 18.0, top: 4.0),
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(pageState.selectedClient.iconUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 64.0,
                  margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  decoration: BoxDecoration(
                    color: const Color(ColorConstants.primary_bg_grey),
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: ElevationToShadow.values.elementAt(1),
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          pageState.selectedClient.firstName + " " + pageState.selectedClient.lastName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: const Color(ColorConstants.primary_dark),
                          ),
                        ),
                        Text(
                          "Upcoming Job: Sun, October 13",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            color: const Color(ColorConstants.primary_dark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Client getClient(int index, ClientsPageState pageState){
    return pageState.filterType.contains("Leads") ? pageState.leads.elementAt(index) : pageState.clients.elementAt(index);
  }
}

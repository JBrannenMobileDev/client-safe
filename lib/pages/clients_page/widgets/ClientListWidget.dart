import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/clients_page/ClientsPage.dart';
import 'package:client_safe/pages/clients_page/ClientsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
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
                margin: EdgeInsets.only(left: 32.0, right: 16.0, top: 4.0),
                height: 44.0,
                width: 44.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(getClient(clientIndex, pageState).iconUrl),
                    fit: BoxFit.contain,
                  ),
                  color: const Color(ColorConstants.primary_bg_grey),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
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
                          getClient(clientIndex, pageState).firstName + " " + getClient(clientIndex, pageState).lastName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: const Color(ColorConstants.primary_black),
                          ),
                        ),
                        Text(
                          "Upcoming Job:  Sun, October 13",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            color: const Color(ColorConstants.primary_bg_grey_dark),
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
    return pageState.filterType == ClientsPage.FILTER_TYPE_ALL
        ? pageState.all.elementAt(index) : pageState.filterType == ClientsPage.FILTER_TYPE_CLIENTS
        ? pageState.clients.elementAt(index) : pageState.leads.elementAt(index);
  }
}

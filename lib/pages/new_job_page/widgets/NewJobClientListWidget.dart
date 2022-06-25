import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewJobClientListWidget extends StatelessWidget {
  final int clientIndex;

  NewJobClientListWidget(this.clientIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          TextButton(
            style: Styles.getButtonStyle(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(32.0),
              ),
              color: pageState.filteredClients.elementAt(clientIndex).documentId == pageState.selectedClient?.documentId ? Color(ColorConstants.getBlueDark()) : Colors.transparent,
            ),
        onPressed: () {
          pageState.onClientSelected(pageState.filteredClients.elementAt(clientIndex));
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 2.0, bottom: 2.0),
              height: 44.0,
              width: 44.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(pageState.filteredClients.elementAt(clientIndex).iconUrl),
                  fit: BoxFit.contain,
                ),
                color: const Color(ColorConstants.primary_bg_grey),
                borderRadius: BorderRadius.all(Radius.circular(22.0)),
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
                        pageState.filteredClients.elementAt(clientIndex).getClientFullName(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: pageState.filteredClients.elementAt(clientIndex).documentId == pageState.selectedClient?.documentId ? Colors.white : Color(ColorConstants.primary_black),
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

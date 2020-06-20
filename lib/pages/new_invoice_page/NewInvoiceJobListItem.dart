import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewInvoiceJobListItem extends StatelessWidget {
  final int index;

  NewInvoiceJobListItem(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewInvoicePageState>(
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          new FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(32.0),
            ),
            color: pageState.filteredJobs.elementAt(index).id == pageState.selectedJob?.id ? Color(ColorConstants.getBlueDark()) : Colors.transparent,
        onPressed: () {
          pageState.onJobSelected(pageState.filteredJobs.elementAt(index));
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 2.0, bottom: 2.0),
              height: 44.0,
              width: 44.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: pageState.filteredJobs.elementAt(index).stage.getStageImage(),
                  fit: BoxFit.contain,
                ),
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
                        pageState.filteredJobs.elementAt(index).jobTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: pageState.filteredJobs.elementAt(index).id == pageState.selectedJob?.id ? Colors.white : Color(ColorConstants.primary_black),
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

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class NewInvoiceJobListItem extends StatelessWidget {
  final int index;

  NewInvoiceJobListItem(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewInvoicePageState>(
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          TextButton(
            style: Styles.getButtonStyle(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(32.0),
              ),
              color: pageState.filteredJobs!.elementAt(index).documentId == pageState.selectedJob?.documentId ? Color(ColorConstants.getBlueDark()) : Colors.transparent,
            ),

        onPressed: () {
          pageState.onJobSelected!(pageState.filteredJobs!.elementAt(index));
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 2.0, bottom: 2.0),
              height: 44.0,
              width: 44.0,
              child: pageState.filteredJobs!.elementAt(index).stage!.getStageImage(Color(ColorConstants.getPeachDark())),
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
                        text: pageState.filteredJobs!.elementAt(index).jobTitle,
                        textAlign: TextAlign.start,
                        color: pageState.filteredJobs!.elementAt(index).documentId == pageState.selectedJob?.documentId ? Color(ColorConstants.getPrimaryWhite()) : Color(ColorConstants.getPrimaryBlack()),
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

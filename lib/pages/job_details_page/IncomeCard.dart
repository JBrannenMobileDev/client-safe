import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/widgets/DandyLightTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../AppState.dart';
import '../../utils/DandyToastUtil.dart';
import '../../utils/TextFormatterUtil.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_contact_pages/NewContactPageState.dart';
import 'JobDetailsPageState.dart';
import 'document_items/DocumentItem.dart';

class IncomeCard extends StatefulWidget {
  final Function onSendInvoiceSelected;

  IncomeCard({this.onSendInvoiceSelected});

  @override
  State<StatefulWidget> createState() {
    return _IncomeCard(onSendInvoiceSelected);
  }
}

class _IncomeCard extends State<IncomeCard> {
  DateTime newDateTimeHolder;
  final Function onSendInvoiceSelected;

  _IncomeCard(this.onSendInvoiceSelected);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      onInit: (store) {
        newDateTimeHolder = store.state.jobDetailsPageState.job.selectedTime;
      },
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16, top: 26, right: 16, bottom: 0),
            height: 172,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Income',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    DocumentItem document = containsInvoiceDocument(pageState);
                    if(pageState.job.priceProfile != null) {
                      if(document == null) {
                        pageState.onAddInvoiceSelected();
                        UserOptionsUtil.showNewInvoiceDialog(context, onSendInvoiceSelected);
                      }else{
                        UserOptionsUtil.showInvoiceOptionsDialog(context, onSendInvoiceSelected);
                      }
                    } else {
                      DandyToastUtil.showErrorToast('Please select a price package for this job before creating an invoice.');
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, left: 16, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 16),
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Image.asset(
                                  'assets/images/icons/invoices_icon_white.png',
                                  height: 32.0,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Invoice Document',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              color: Color(
                                  ColorConstants.getPrimaryBlack()),
                            ),
                          ],
                        ),
                        Container(
                          height: 36,
                          margin: EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.chevron_right,
                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  DocumentItem containsInvoiceDocument(JobDetailsPageState pageState) {
    pageState.documents.forEach((document) {
      if(document.getDocumentType() == DocumentItem.DOCUMENT_TYPE_INVOICE){
        return document;
      }
    });
    return null;
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }
}

import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/pages/IncomeAndExpenses/InvoiceItem.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../widgets/TextDandyLight.dart';

class DocumentsCard extends StatelessWidget {
  final Function onSendInvoiceSelected;

  DocumentsCard({this.pageState, this.onSendInvoiceSelected});

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 26.0),
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        decoration: new BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: new BorderRadius.all(Radius.circular(24.0))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Documents',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.primary_black),
                    ),
              ),
              pageState.documents.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 0.0, bottom: 16.0),
                      reverse: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      key: _listKey,
                      itemCount: pageState.documents.length,
                      itemBuilder: _buildItem,
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 4.0, bottom: 0.0, left: 26.0, right: 26.0),
                      height: 64.0,
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'No documents have been added to this job yet.',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
            ]),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = pageState.documents.elementAt(index);

    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () async {
        switch(item.getDocumentType()) {
          case DocumentItem.DOCUMENT_TYPE_INVOICE:
            UserOptionsUtil.showViewInvoiceDialog(context, pageState.invoice, await JobDao.getJobById(pageState.invoice.jobDocumentId), onSendInvoiceSelected);
            break;
          case DocumentItem.DOCUMENT_TYPE_CONTRACT:
            NavigationUtil.onContractSelected(context, pageState.job.proposal.contract, pageState.job.proposal.contract.contractName, false, pageState.job.documentId);
            break;
        }
      },
      child: Container(
        height: 54.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: item.buildIconItem(context),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: item.buildTitle(context),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                switch(item.getDocumentType()) {
                  case DocumentItem.DOCUMENT_TYPE_INVOICE:
                    _ackAlert(context, pageState);
                    break;
                  case DocumentItem.DOCUMENT_TYPE_CONTRACT:
                    _ackContractAlert(context, pageState);
                    break;
                };
              },
              child: Container(
                margin: EdgeInsets.only(right: 12.0),
                height: 24.0,
                width: 24.0,
                child: Image.asset('assets/images/icons/trash_icon_peach.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ackAlert(BuildContext context, JobDetailsPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This invoice will be permanently deleted.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteInvoiceSelected(pageState.invoice);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This invoice will be permanently deleted.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteInvoiceSelected(pageState.invoice);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _ackContractAlert(BuildContext context, JobDetailsPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This contract will be permanently removed from this job.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteContractSelected(pageState.job.proposal.contract);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This invoice will be permanently removed from this job.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteContractSelected(pageState.job.proposal.contract);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

}

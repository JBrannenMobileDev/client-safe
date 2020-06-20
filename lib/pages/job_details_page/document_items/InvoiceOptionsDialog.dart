import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPage.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InvoiceOptionsDialog extends StatefulWidget {
  final Function onSendInvoiceSelected;

  InvoiceOptionsDialog(this.onSendInvoiceSelected);

  @override
  _InvoiceOptionsDialogState createState() {
    return _InvoiceOptionsDialogState(onSendInvoiceSelected);
  }
}

class _InvoiceOptionsDialogState extends State<InvoiceOptionsDialog>
    with AutomaticKeepAliveClientMixin {
  final jobTitleTextController = TextEditingController();
  final Function onSendInvoiceSelected;

  _InvoiceOptionsDialogState(this.onSendInvoiceSelected);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 250.0,
              padding: EdgeInsets.only(left: 32.0, right: 32.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Text(
                      'This job already has an invoice. Would you like to replace it with a new invoice?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                        Navigator.of(context).pop();
                        pageState.onAddInvoiceSelected();
                        UserOptionsUtil.showNewInvoiceDialog(context, onSendInvoiceSelected);
                        },
                        child: Container(
                          height: 112.0,
                          width: 112.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPrimaryColor())
                          ),
                          child: Text(
                            'YES',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 48.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 112.0,
                          width: 112.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                          child: Text(
                            'NO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 48.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

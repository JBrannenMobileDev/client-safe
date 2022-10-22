import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPage.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SendInvoicePromptDialog extends StatefulWidget {
  final int invoiceId;
  final Function onSendInvoiceSelected;

  SendInvoicePromptDialog(this.invoiceId, this.onSendInvoiceSelected);

  @override
  _SendInvoicePromptDialogState createState() {
    return _SendInvoicePromptDialogState(invoiceId, onSendInvoiceSelected);
  }
}

class _SendInvoicePromptDialogState extends State<SendInvoicePromptDialog>
    with AutomaticKeepAliveClientMixin {
  final jobTitleTextController = TextEditingController();
  final int invoiceId;
  final Function onSendInvoiceSelected;

  _SendInvoicePromptDialogState(this.invoiceId, this.onSendInvoiceSelected);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Dialog(
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
                      'Would you like to send this invoice now ?',
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
                        onSendInvoiceSelected != null ? onSendInvoiceSelected() : DoNothingAction();
                        IntentLauncherUtil.shareInvoiceById(invoiceId);
                        Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 96.0,
                          width: 96.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPrimaryColor())
                          ),
                          child: Text(
                            'YES',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32.0,
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
                          height: 96.0,
                          width: 96.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                          child: Text(
                            'NO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32.0,
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}


import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/Job.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class SendInvoicePromptDialog extends StatefulWidget {
  final int invoiceId;
  final Function onSendInvoiceSelected;
  final Job job;

  SendInvoicePromptDialog(this.invoiceId, this.onSendInvoiceSelected, this.job);

  @override
  _SendInvoicePromptDialogState createState() {
    return _SendInvoicePromptDialogState(invoiceId, onSendInvoiceSelected, job);
  }
}

class _SendInvoicePromptDialogState extends State<SendInvoicePromptDialog>
    with AutomaticKeepAliveClientMixin {
  final jobTitleTextController = TextEditingController();
  final int invoiceId;
  final Function onSendInvoiceSelected;
  final Job job;

  _SendInvoicePromptDialogState(this.invoiceId, this.onSendInvoiceSelected, this.job);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 250.0,
              width: 450,
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
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Would you like to send this invoice now ?',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          onSendInvoiceSelected != null ? onSendInvoiceSelected() : DoNothingAction();
                          Navigator.of(context).pop();
                          NavigationUtil.onShareWIthClientSelected(context, job);
                          EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_FROM_SEND_INVOICE_PROMPT);
                        },
                        child: Container(
                          height: 96.0,
                          width: 96.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPrimaryColor())
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.EXTRA_LARGE_TEXT,
                            text: 'YES',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
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
                          child: TextDandyLight(
                            type: TextDandyLight.EXTRA_LARGE_TEXT,
                            text: 'NO',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
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

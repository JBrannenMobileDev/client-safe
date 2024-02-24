import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/pages/job_details_page/document_items/QuestionnaireDocument.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../models/Profile.dart';
import '../../widgets/TextDandyLight.dart';

class DocumentsCard extends StatelessWidget {
  final Function onSendInvoiceSelected;

  DocumentsCard({Key key, this.pageState, this.onSendInvoiceSelected, this.profile}) : super(key: key);

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final JobDetailsPageState pageState;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 26.0),
      child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: const BorderRadius.all(Radius.circular(12.0))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Documents',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
              ),
              pageState.documents.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 16.0),
                      reverse: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      key: _listKey,
                      itemCount: pageState.documents.length,
                      itemBuilder: _buildItem,
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 4.0, bottom: 0.0, left: 26.0, right: 26.0),
                      height: 64.0,
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'No documents have been added to this job yet.',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
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
            UserOptionsUtil.showContractOptionsSheet(context, pageState.job, profile, openContractEditPage);
            break;
          case DocumentItem.DOCUMENT_TYPE_QUESTIONNAIRE:
            UserOptionsUtil.showQuestionnaireOptionsSheet(context, getSelectedQuestionnaire(pageState.job.proposal.questionnaires, pageState.documents.elementAt(index)), openQuestionnaireEditPage);
        }
      },
      child: SizedBox(
        height: 54.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: item.buildIconItem(context),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: item.buildTitle(context),
                ),
              ],
            ),
            Container(
              height: 36,
              margin: const EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.chevron_right,
                color: Color(ColorConstants.getPrimaryBackgroundGrey()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openQuestionnaireEditPage(BuildContext context, Questionnaire questionnaire) {
    NavigationUtil.onQuestionnaireSelected(context, questionnaire, questionnaire.title, false, pageState.job.documentId, _ackQuestionnaireAlert);
  }

  void openContractEditPage(BuildContext context) {
    NavigationUtil.onContractSelected(context, pageState.job.proposal.contract, pageState.job.proposal.contract.contractName, false, pageState.job.documentId, _ackQuestionnaireAlert);
  }

  Future<void> _ackContractAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This contract will be permanently removed from this job.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteContractSelected(pageState.job.proposal.contract);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This contract will be permanently removed from this job.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteContractSelected(pageState.job.proposal.contract);
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _ackQuestionnaireAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This questionnaire will be permanently removed from this job.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                // pageState.onDeleteContractSelected(pageState.job.proposal.contract);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This questionnaire will be permanently removed from this job.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                // pageState.onDeleteContractSelected(pageState.job.proposal.contract);
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Questionnaire getSelectedQuestionnaire(List<Questionnaire> questionnaires, DocumentItem documentItem) {
    QuestionnaireDocument questionnaireDocument = documentItem;
    return questionnaireDocument.questionnaire;
  }

}

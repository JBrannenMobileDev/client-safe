import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';
import '../contracts_page/ContractsPage.dart';

class ContractOptionsDialog extends StatefulWidget {

  @override
  _ContractOptionsDialogState createState() {
    return _ContractOptionsDialogState();
  }
}

class _ContractOptionsDialogState extends State<ContractOptionsDialog>
    with AutomaticKeepAliveClientMixin {
  final jobTitleTextController = TextEditingController();

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
              width: MediaQuery.of(context).size.width,
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
                      text: 'This job already has a contract. Would you like to replace it with a new unsigned contract?',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) => ContractsPage(jobDocumentId: pageState.job!.documentId)),
                        );
                        },
                        child: Container(
                          height: 112.0,
                          width: 112.0,
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
                          height: 112.0,
                          width: 112.0,
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
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

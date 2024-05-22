import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/Contract.dart';
import '../../../models/JobStage.dart';
import '../../../utils/styles/Styles.dart';

class ContractsItem extends StatelessWidget{
  final Contract contract;
  final DashboardPageState? pageState;
  const ContractsItem({Key? key, required this.contract, this.pageState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () {
        NavigationUtil.onInAppPreviewContractSelected(context, contract.jsonTerms!);
      },
      child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 18.0),
      child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(right: 18.0),
                  height: 38.0,
                  width: 38.0,
                  child: JobStage.getContractImage(contract.signedByClient ?? false, Color(ColorConstants.getPeachDark())),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: contract.clientName,
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: contract.contractName,
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryGreyMedium()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            )
          ],
        ),
      ),
    );
  }
}
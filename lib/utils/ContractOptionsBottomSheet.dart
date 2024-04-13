import 'package:dandylight/models/Client.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import '../../widgets/TextDandyLight.dart';
import 'DandyToastUtil.dart';
import 'intentLauncher/IntentLauncherUtil.dart';

class ContractOptionsBottomSheet extends StatefulWidget {
  final String jsonTerms;
  final Function openContractEditPage;

  ContractOptionsBottomSheet(this.jsonTerms, this.openContractEditPage);


  @override
  State<StatefulWidget> createState() {
    return _ContractOptionsBottomSheetPageState(jsonTerms, openContractEditPage);
  }
}

class _ContractOptionsBottomSheetPageState extends State<ContractOptionsBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
  final String jsonTerms;
  final Function openContractEditPage;

  _ContractOptionsBottomSheetPageState(this.jsonTerms, this.openContractEditPage);


  @override
  Widget build(BuildContext context) =>
      Container(
        height: 264.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          color: Color(ColorConstants.getPrimaryWhite()),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 32),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Contract options',
              ),
            ),
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      openContractEditPage(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      alignment: Alignment.center,
                      width: 264,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: Color(ColorConstants.getPeachDark())
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Edit Contract',
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      NavigationUtil.onInAppPreviewContractSelected(context, jsonTerms);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 264,
                      height: 54,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: Color(ColorConstants.getPeachDark())
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Preview Contract',
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
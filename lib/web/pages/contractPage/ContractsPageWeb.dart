import 'dart:convert';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/web/pages/contractPage/ContractPageFullPage.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../ClientPortalPageState.dart';
import 'package:redux/redux.dart';

class ContractsPageWeb extends StatefulWidget {
  final ScrollController? scrollController;

  ContractsPageWeb({this.scrollController});

  @override
  State<StatefulWidget> createState() {
    return _ContractsPageWebState(scrollController!);
  }
}

class _ContractsPageWebState extends State<ContractsPageWeb> {
  final ScrollController? scrollController;

  _ContractsPageWebState(this.scrollController);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientPortalPageState>(
        converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
        builder: (BuildContext context, ClientPortalPageState pageState) =>
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 1080),
              child: Container(
                padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 32, bottom: 48),
                      child: TextDandyLight(
                        type: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight.EXTRA_LARGE_TEXT : TextDandyLight.LARGE_TEXT,
                        fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                        text: 'Contracts',
                      ),
                    ),
                    SizedBox(
                      width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1440 : MediaQuery.of(context).size.width,
                      child: GridView.builder(
                        itemCount: pageState.proposal!.contracts!.length,
                        itemBuilder: (context, index) => buildItem(index, pageState),
                        physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4 : DeviceType.getDeviceTypeByContext(context) == Type.Tablet ? 2 : 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
      );

  double getPageWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(width >= 1440) return 1440;
    return width;
  }

  Widget buildItem(int index, ClientPortalPageState pageState) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContractFullPage(contract: pageState.proposal!.contracts!.elementAt(index))));
      },
      child: SizedBox(
        height: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : 2.25),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 8),
              width: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : DeviceType.getDeviceTypeByContext(context) == Type.Tablet ? 2.25 : 1),
              child: Container(
                height: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 108 : 108,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(ColorConstants.getPrimaryGreyLight()),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      height: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 32 : 54,
                      width: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 32 : 54,
                      child: Image.asset('navIcons/contract_outline.png', color: Color(ColorConstants.getPrimaryBlack())),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            alignment: Alignment.centerLeft,
                            child: TextDandyLight(
                              textAlign: TextAlign.start,
                              type: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? TextDandyLight.SMALL_TEXT : TextDandyLight.MEDIUM_TEXT,
                              text: pageState.proposal!.contracts!.elementAt(index).contractName,
                              maxLines: 2,
                              isBold: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            alignment: Alignment.centerLeft,
                            child: TextDandyLight(
                              textAlign: TextAlign.start,
                              type: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? TextDandyLight.SMALL_TEXT : TextDandyLight.MEDIUM_TEXT,
                              text: (pageState.proposal!.contracts!.elementAt(index).signedByClient ?? false) ? 'Signed' : 'Unsigned',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (pageState.proposal!.contracts!.elementAt(index).isVoid ?? false) ? Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 0),
              height: 142,
              width: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : DeviceType.getDeviceTypeByContext(context) == Type.Tablet ? 2.25 : 1),              padding: const EdgeInsets.all(4),
              child: Icon(Icons.close, color: Color(ColorConstants.error_red), size: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 72 : 84),
            ) : const SizedBox(),
            !(pageState.proposal!.contracts!.elementAt(index).isVoid ?? false) ? Container(
              height: 36,
              width: 36,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: pageState.proposal!.contracts!.elementAt(index).signedByClient ?? false ? ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!) : Color(ColorConstants.getPrimaryGreyMedium()),
                boxShadow: ElevationToShadow[1]
              ),
              child: Icon(Icons.check, color: Color(ColorConstants.getPrimaryWhite()), size: 22,),
            ) : Container(
              alignment: Alignment.center,
              height: 36,
              width: 164,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Color(ColorConstants.error_red),
                  boxShadow: ElevationToShadow[1]
              ),
              child: TextDandyLight(
                textAlign: TextAlign.start,
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'MARKED AS VOID',
                color: Color(ColorConstants.getPrimaryWhite()),
              )
            )
          ],
        ),
      ),
    );
  }
}

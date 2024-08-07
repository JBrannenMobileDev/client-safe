import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/DeviceType.dart';
import '../../../utils/Shadows.dart';
import '../../../widgets/TextDandyLight.dart';
import '../ClientPortalPageState.dart';
import 'package:redux/redux.dart';

class ClientPortalQuestionnairesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClientPortalQuestionnairesPageState();
  }
}

class _ClientPortalQuestionnairesPageState extends State<ClientPortalQuestionnairesPage> {

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
                      text: 'Questionnaires',
                    ),
                  ),
                  SizedBox(
                    width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1440 : MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      itemCount: pageState.proposal!.questionnaires!.length,
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
        NavigationUtil.onAnswerQuestionnaireSelected(context, pageState.proposal!.questionnaires!.elementAt(index), pageState.profile!, pageState.userId, pageState.jobId, false, true, pageState.updateQuestionnaires);
      },
      child: pageState.proposal!.questionnaires!.elementAt(index).hasImage() ? SizedBox(
        height: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : 2.25),
        width: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : 2.25),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(left: 8, top: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 16 : 26, right: 8, bottom: 8),
              height: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 5 : DeviceType.getDeviceTypeByContext(context) == Type.Tablet ? 2.25 : 1),
              width: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : DeviceType.getDeviceTypeByContext(context) == Type.Tablet ? 2.25 : 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(ColorConstants.getPrimaryGreyLight()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  pageState.proposal!.questionnaires!.elementAt(index).hasImage() ? ClipRRect(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)), // Image border
                    child: SizedBox(
                      width: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : DeviceType.getDeviceTypeByContext(context) == Type.Tablet ? 2.25 : 1),
                      height: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 6.5 : DeviceType.getDeviceTypeByContext(context) == Type.Tablet ? 3.5 : 3.5),
                      child: Image.network(
                        pageState.proposal!.questionnaires!.elementAt(index).getDisplayImageUrl(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ) : const SizedBox(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          alignment: Alignment.centerLeft,
                          child: TextDandyLight(
                            textAlign: TextAlign.start,
                            type: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? TextDandyLight.SMALL_TEXT : TextDandyLight.MEDIUM_TEXT,
                            text: pageState.proposal!.questionnaires!.elementAt(index).title ?? "",
                            maxLines: 1,
                            isBold: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          alignment: Alignment.centerLeft,
                          child: TextDandyLight(
                            textAlign: TextAlign.start,
                            type: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? TextDandyLight.SMALL_TEXT : TextDandyLight.MEDIUM_TEXT,
                            text: pageState.proposal!.questionnaires!.elementAt(index).isComplete ?? false ? '(Completed)' : '(${pageState.proposal!.questionnaires!.elementAt(index).getLengthInMinutes()}min)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 36 : 54,
              width: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 36 : 54,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: ElevationToShadow[1],
                  color: pageState.proposal!.questionnaires!.elementAt(index).isComplete ?? false ? ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!) : Color(ColorConstants.getPrimaryGreyMedium())
              ),
              child: Icon(Icons.check, color: Color(ColorConstants.getPrimaryWhite()), size: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 22 : 32),
            )
          ],
        ),
      ) : SizedBox(
        height: getPageWidth(context)/(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 4.5 : 2.25),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(left: 8, top: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 16 : 26, right: 8, bottom: 8),
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
                      child: Image.asset('navIcons/questionnaire_solid.png', color: Color(ColorConstants.getPrimaryBlack())),
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
                              text: pageState.proposal!.questionnaires!.elementAt(index).title ?? '',
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
                              text: pageState.proposal!.questionnaires!.elementAt(index).isComplete ?? false ? '(Completed)' : '(${pageState.proposal!.questionnaires!.elementAt(index).getLengthInMinutes()}min)',
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
            Container(
              height: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 36 : 54,
              width: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 36 : 54,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: ElevationToShadow[1],
                  color: pageState.proposal!.questionnaires!.elementAt(index).isComplete ?? false ? ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!) : Color(ColorConstants.getPrimaryGreyMedium())
              ),
              child: Icon(Icons.check, color: Color(ColorConstants.getPrimaryWhite()), size: DeviceType.getDeviceTypeByContext(context) == Type.Phone ? 22 : 32),
            )
          ],
        ),
      ),
    );
  }
}
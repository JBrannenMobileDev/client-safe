import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'DashboardPageState.dart';


class RequestPMFSurveyBottomSheet extends StatefulWidget {
  const RequestPMFSurveyBottomSheet({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _RequestPMFSurveyBottomSheetState();
  }
}

class _RequestPMFSurveyBottomSheetState extends State<RequestPMFSurveyBottomSheet> with TickerProviderStateMixin {

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color(ColorConstants.getPrimaryBlack());
    }
    return Color(ColorConstants.getPeachDark());
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>
         Container(
           height: 296,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
             child: Column(
               children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 32, left: 12, right: 12),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Would you like to help DandyLight improve our product?',
                    ),
                  ),
                 Container(
                   margin: const EdgeInsets.only(bottom: 8),
                   child: TextDandyLight(
                     type: TextDandyLight.MEDIUM_TEXT,
                     textAlign: TextAlign.center,
                     text: 'Please take this 2 min survey.',
                   ),
                 ),
                  GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchPMFSurvey();
                      pageState.updateCanShowPMF!(false, DateTime.now());
                      EventSender().sendEvent(eventName: EventNames.BT_TAKE_PMF_SURVEY);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 54,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: Color(ColorConstants.getPeachDark())
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Take Survey',
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                 Container(
                   margin: const EdgeInsets.only(top: 32),
                   alignment: Alignment.center,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Checkbox(
                         value: !pageState.profile!.canShowPMFSurvey!,
                         onChanged: (checked) {
                           pageState.updateCanShowPMF!(!checked!, DateTime.now());
                         },
                         checkColor: Color(ColorConstants.getPrimaryWhite()),
                         fillColor: MaterialStateProperty.resolveWith(getColor),
                       ),
                       TextDandyLight(
                         type: TextDandyLight.SMALL_TEXT,
                         text: 'do not show again',
                         color: Color(ColorConstants.getPrimaryBlack()),
                       ),
                       const SizedBox(width: 14)
                     ],
                   ),
                 ),
               ],
             ),
         ),
    );
}
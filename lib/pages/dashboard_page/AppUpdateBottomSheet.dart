import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_store/open_store.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../models/Job.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'DashboardPageState.dart';


class AppUpdateBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AppUpdateBottomSheetState();
  }
}

class _AppUpdateBottomSheetState extends State<AppUpdateBottomSheet> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>
         Container(
           height: 296,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
             child: Column(
               children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16, left: 12, right: 12),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: pageState.appSettings.updateTitle,
                    ),
                  ),
                 Container(
                   margin: EdgeInsets.only(bottom: 48, left: 16, right: 16),
                   child: TextDandyLight(
                     type: TextDandyLight.MEDIUM_TEXT,
                     textAlign: TextAlign.center,
                     text: pageState.appSettings.updateMessage,
                   ),
                 ),
                  GestureDetector(
                    onTap: () {
                      OpenStore.instance.open(
                          appStoreId: '6444910643', // AppStore id of your app for iOS
                          androidAppBundleId: 'com.dandylight.mobile', // Android app bundle package name
                      );
                      EventSender().sendEvent(eventName: EventNames.BT_UPDATE_APP);
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
                        text: 'Update App',
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
               ],
             ),
         ),
    );
}
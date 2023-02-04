import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../DashboardPageState.dart';


class RestorePurchasesBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState();
  }
}

class _BottomSheetPageState extends State<RestorePurchasesBottomSheet> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>
         Stack(
           alignment: Alignment.bottomCenter,
           children: [
             Container(
               height: 300,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 16.0, right: 16.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(top: 24, bottom: 24.0),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'New Device',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.primary_black),
                     ),
                   ),
                   Container(
                     margin: EdgeInsets.only(top: 8, bottom: 24.0, left: 24, right: 24),
                     child: TextDandyLight(
                       type: TextDandyLight.MEDIUM_TEXT,
                       text: 'We noticed you logged in on a new device. To continue using your current subscription pleases select the restore purchases button below.',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.primary_black),
                     ),
                   ),
                 ],
               ),
             ),
             GestureDetector(
               onTap: () {
                 showSuccessAnimation();
               },
               child: Container(
                 margin: EdgeInsets.only(bottom: 54),
                 child: TextDandyLight(
                   type: TextDandyLight.LARGE_TEXT,
                   text: 'Restore Purchases',
                   textAlign: TextAlign.center,
                   color: Color(ColorConstants.getPeachDark()),
                 ),
               ),
             ),
           ],
         ),
    );

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
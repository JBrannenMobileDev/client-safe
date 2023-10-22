import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../widgets/TextDandyLight.dart';


class PageExplainationBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState();
  }
}

class _BottomSheetPageState extends State<PageExplainationBottomSheet> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, IncomeAndExpensesPageState>(
    converter: (Store<AppState> store) => IncomeAndExpensesPageState.fromStore(store),
    builder: (BuildContext context, IncomeAndExpensesPageState pageState) =>
         Stack(
           alignment: Alignment.topRight,
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
                       text: 'About this page',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                   Container(
                     margin: EdgeInsets.only(top: 8, bottom: 24.0, left: 24, right: 24),
                     child: TextDandyLight(
                       type: TextDandyLight.MEDIUM_TEXT,
                       text: 'Your income is tracked automatically when you receive payment or complete a job.\n\nYou can generate a new invoice here or on your job details page.',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                 ],
               ),
             ),
             GestureDetector(
               onTap: () {
                 pageState.onIncomeInfoSeen();
                 Navigator.of(context).pop();
               },
               child: Container(
                 margin: EdgeInsets.only(top: 16, right: 16.0),
                 child: TextDandyLight(
                   type: TextDandyLight.LARGE_TEXT,
                   text: 'Ok',
                   textAlign: TextAlign.center,
                   color: Color(ColorConstants.getPeachDark()),
                 ),
               ),
             ),
           ],
         ),
    );
}
import 'dart:async';

import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/widgets/DandyLightTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../utils/KeyboardUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_contact_pages/NewContactPageState.dart';

class GenerateDiscountCodeBottomSheet extends StatefulWidget {
  final String discountType;

  GenerateDiscountCodeBottomSheet(this.discountType);

  @override
  State<StatefulWidget> createState() {
    return _GenerateDiscountCodeBottomSheetState(discountType);
  }
}

class _GenerateDiscountCodeBottomSheetState extends State<GenerateDiscountCodeBottomSheet> with TickerProviderStateMixin {
  final notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  bool hasError = false;
  String currentText = "";
  bool hasPopped = false;
  final String discountType;

  _GenerateDiscountCodeBottomSheetState(this.discountType);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, MainSettingsPageState>(
    onDidChange: (previous, current) {
      if(previous!.discountCode!.isEmpty && current.discountCode!.isNotEmpty && !hasPopped) {
        hasPopped = true;
        Navigator.of(context).pop();
      }
    },
    converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
    builder: (BuildContext context, MainSettingsPageState pageState) =>
         Container(
           height: KeyboardUtil.isVisible(context) ? 564 : 264,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: EdgeInsets.only(left: 16.0, right: 16.0),
             child:
             Column(
               children: [
                 Container(
                   margin: EdgeInsets.only(top: 16),
                   child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Enter Instagram URL',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getBlueDark())
                   ),
                 ),
                 Container(
                   height: 64,
                   decoration: BoxDecoration(
                     border: Border.all(
                       color: Color(ColorConstants.getBlueDark()),
                       width: 1,
                     ),
                     borderRadius: BorderRadius.circular(16)
                   ),
                   margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 8),
                   child: DandyLightTextField(
                     notesController,
                     "Instagram URL",
                     TextInputType.text,
                     110.0,
                     pageState.onInstaUrlChanged!,
                     NewContactPageState.NO_ERROR,
                     TextInputAction.done,
                     _notesFocusNode,
                     onAction,
                     TextCapitalization.sentences,
                     null,
                     true,
                   ),
                 ),
                 TextButton(
                   style: Styles.getButtonStyle(),
                   onPressed: () {
                     if(notesController.text.length > 0) {
                       switch(discountType){
                         case DiscountCodes.LIFETIME_FREE:
                           pageState.generateFreeDiscountCode!();
                           break;
                         case DiscountCodes.FIFTY_PERCENT_TYPE:
                           pageState.generate50DiscountCode!();
                           break;
                         case DiscountCodes.FIRST_3_MONTHS_FREE:
                           pageState.generate3MonthsFreeCode!();
                           break;
                       }
                     } else if(discountType == DiscountCodes.FIRST_3_MONTHS_FREE) {
                       pageState.generate3MonthsFreeCode!();
                     }
                   },
                   child: Container(
                     alignment: Alignment.center,
                     margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
                     height: 48.0,
                     width: 216.0,
                     decoration: BoxDecoration(
                         color: Color(ColorConstants.getBlueDark()),
                         borderRadius: BorderRadius.circular(32.0)
                     ),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Generate Code',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getPrimaryWhite()),
                     ),
                   ),
                 ),
               ],
             ),
         ),
    );

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
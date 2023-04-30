import 'dart:async';

import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../utils/KeyboardUtil.dart';
import '../../widgets/TextDandyLight.dart';

class EnterDiscountCodeBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnterDiscountCodeBottomSheetState();
  }
}

class _EnterDiscountCodeBottomSheetState extends State<EnterDiscountCodeBottomSheet> with TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  bool hasPopped = false;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ManageSubscriptionPageState>(
    onDidChange: (previous, current) {
      if(previous.discountType.isEmpty && current.discountType.isNotEmpty && !hasPopped) {
        hasPopped = true;
        Navigator.of(context).pop();
      }
    },
    converter: (Store<AppState> store) => ManageSubscriptionPageState.fromStore(store),
    builder: (BuildContext context, ManageSubscriptionPageState pageState) =>
         Container(
           height: KeyboardUtil.isVisible(context) ? 564 : 224,
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
                       text: 'Enter Discount Code',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getBlueDark())
                   ),
                 ),
                 pageState.showDiscountError ? Container(
                   margin: EdgeInsets.only(top: 16),
                   child: TextDandyLight(
                       type: TextDandyLight.MEDIUM_TEXT,
                       text: 'Invalid code',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.error_red)
                   ),
                 ) : SizedBox(height: 35,),
                 Container(
                   width: 300,
                   margin: EdgeInsets.only(top: 16),
                   child: PinCodeTextField(
                     appContext: context,
                     pastedTextStyle: TextStyle(
                       color: Color(ColorConstants.getBlueDark()),
                       fontWeight: FontWeight.bold,
                     ),
                     length: 6,
                     obscureText: false,
                     animationType: AnimationType.fade,
                     pinTheme: PinTheme(
                       shape: PinCodeFieldShape.box,
                       borderRadius: BorderRadius.circular(8),
                       fieldHeight: 56,
                       fieldWidth: 40,
                       inactiveColor: Color(pageState.showDiscountError ? ColorConstants.error_red : ColorConstants.getPrimaryGreyMedium()),
                       activeColor: Color(pageState.showDiscountError ? ColorConstants.error_red : ColorConstants.getPrimaryGreyMedium()),
                       selectedColor: Color(pageState.showDiscountError ? ColorConstants.error_red : ColorConstants.getBlueDark()),
                     ),
                     cursorColor: Colors.black,
                     animationDuration: const Duration(milliseconds: 300),
                     enableActiveFill: false,
                     errorAnimationController: errorController,
                     controller: textEditingController,
                     keyboardType: TextInputType.text,

                     onCompleted: (v) {
                       debugPrint("Completed");
                     },
                     // onTap: () {
                     //   print("Pressed");
                     // },
                     onChanged: (value) {
                       debugPrint(value);
                       setState(() {
                         currentText = value;
                         pageState.checkIfDiscountExists(value);
                       });
                     },
                     beforeTextPaste: (text) {
                       debugPrint("Allowing to paste $text");
                       //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                       //but you can show anything you want here, like your pop up saying wrong paste format or etc
                       return false;
                     },
                   ),
                 ),
               ],
             ),
         ),
    );
}
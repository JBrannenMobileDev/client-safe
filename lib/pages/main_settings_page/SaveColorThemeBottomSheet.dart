import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../widgets/DandyLightTextField.dart';
import '../common_widgets/LoginTextField.dart';
import 'ColorThemeWidget.dart';


class SaveColorThemeBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SaveColorThemeBottomSheetPageState();
  }
}

class _SaveColorThemeBottomSheetPageState extends State<SaveColorThemeBottomSheet> with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, MainSettingsPageState>(
    converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
    builder: (BuildContext context, MainSettingsPageState pageState) =>
         Container(
           height: 250,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: <Widget>[
                   GestureDetector(
                     onTap: () {

                       Navigator.of(context).pop();
                     },
                     child: Container(
                       alignment: Alignment.center,
                        width: 64,
                        height: 54,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Save',
                          textAlign: TextAlign.center,
                          color: controller.text.length > 0 ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryGreyMedium()),
                        )
                     ),
                   ),
                   Container(
                     width: double.infinity,
                     alignment: Alignment.center,
                     child: Container(
                       width: 300,
                       margin: EdgeInsets.only(top: 8),
                       child: TextField(
                           enabled: true,
                           controller: controller,
                           cursorColor: Color(ColorConstants.getPrimaryBlack()),
                           onChanged: (text) {
                              setState(() {

                              });
                           },
                           decoration: InputDecoration(
                             alignLabelWithHint: true,
                             labelStyle: TextStyle(
                                 fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                                 fontFamily: TextDandyLight.getFontFamily(),
                                 fontWeight: TextDandyLight.getFontWeight(),
                                 color: Color(ColorConstants.getPrimaryBlack())
                             ),
                             hintText: 'Theme Name',
                             fillColor: Colors.white,
                             focusedBorder: OutlineInputBorder(
                               borderSide: BorderSide(
                                 color: Color(ColorConstants.getPrimaryGreyMedium()),
                                 width: 1.0,
                               ),
                               borderRadius: BorderRadius.circular(24),
                             ),
                             enabledBorder: OutlineInputBorder(
                               borderSide: BorderSide(color: Color(ColorConstants.getPrimaryGreyMedium()), width: 1.0),
                               borderRadius: BorderRadius.circular(28),
                             ),
                             contentPadding: EdgeInsets.all(16),
                             isDense: true,
                           ),
                           keyboardType: TextInputType.name,
                           textCapitalization: TextCapitalization.words,
                           maxLines: 1,
                           style: TextStyle(
                               fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                               fontFamily: TextDandyLight.getFontFamily(),
                               fontWeight: TextDandyLight.getFontWeight(),
                               color: Color(ColorConstants.getPrimaryBlack()))
                       ),
                     ),
                   ),
                   Container(
                     alignment: Alignment.center,
                     width: double.infinity,
                     child: Container(
                       width: 300,
                       margin: EdgeInsets.only(top: 32),
                       child: Row(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             height: 48,
                             width: 48,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(24),
                                 color: Color(ColorConstants.getBlueDark())
                             ),
                           ),
                           Container(
                             height: 48,
                             width: 48,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(24),
                                 color: Color(ColorConstants.getPeachDark())
                             ),
                           ),
                           Container(
                             height: 48,
                             width: 48,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(24),
                                 border: Border.all(
                                     width: 1,
                                     color: Color(ColorConstants.getPrimaryBackgroundGrey())
                                 ),
                                 color: Color(ColorConstants.getPrimaryWhite())
                             ),
                           ),
                           Container(
                             height: 48,
                             width: 48,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(24),
                                 color: Color(ColorConstants.getPeachDark())
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
         ),
    );

  void doNothing(String text) {

  }
}
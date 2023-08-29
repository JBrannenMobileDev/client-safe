import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../AppState.dart';
import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';
import 'MainSettingsPageState.dart';

class ColorThemeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
  onInit: (store) {

  },
  converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
  builder: (BuildContext context, MainSettingsPageState pageState) => Container(
      margin: EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            text: pageState.selectedColorTheme.themeName,
            textAlign: TextAlign.center,
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          Row(
            children: [
              ColorCircle(pageState.selectedColorTheme.iconColor),
              ColorCircle(pageState.selectedColorTheme.iconTextColor),
              ColorCircle(pageState.selectedColorTheme.buttonColor),
              ColorCircle(pageState.selectedColorTheme.buttonTextColor),
              ColorCircle(pageState.selectedColorTheme.bannerColor),
              Container(
                child: Icon(
                  Icons.chevron_right,
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                ),
              ),
            ],
          ),
        ],
      ),
    )
      );

  Widget ColorCircle(String color) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      height: 26,
      width: 26,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            width: 1,
            color: Color(ColorConstants.isWhiteString(color) ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryWhite()),
          ),
          color: ColorConstants.hexToColor(color)
      ),
    );
  }

}
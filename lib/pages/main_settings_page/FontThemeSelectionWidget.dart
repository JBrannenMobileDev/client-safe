import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/pages/main_settings_page/SaveColorThemeBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';

import '../../utils/Shadows.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/DandyLightPainter.dart';
import '../../widgets/TextDandyLight.dart';
import 'ColorThemeSelectionBottomSheet.dart';
import 'ColorThemeWidget.dart';
import 'FontSelectionBottomSheet.dart';
import 'FontThemeSelectionBottomSheet.dart';
import 'FontThemeWidget.dart';
import 'PreviewOptionsBottomSheet.dart';

class FontThemeSelectionWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FontThemeSelectionWidgetState();
  }
}

class _FontThemeSelectionWidgetState extends State<FontThemeSelectionWidget> with TickerProviderStateMixin {

  void _showFontThemeSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return FontThemeSelectionBottomSheet();
      },
    );
  }

  void _showFontSelectionSheet(BuildContext context, String id) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return FontSelectionBottomSheet(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
        onInit: (store) {
          store.dispatch(ClearBrandingStateAction(store.state.mainSettingsPageState, store.state.mainSettingsPageState.profile));
        },
        converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              alignment: Alignment.center,
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Font Theme',
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 124),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(ColorConstants.getPrimaryWhite())
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          pageState.logoImageSelected ? ClipRRect(
                            borderRadius: new BorderRadius.circular(58.0),
                            child: Image(
                              fit: BoxFit.cover,
                              width: 116,
                              height: 116,
                              image: FileImage(File(pageState.resizedLogoImage.path)),
                            ),
                          ) : Container(
                            alignment: Alignment.center,
                            height: 116,
                            width: 116,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.hexToColor(pageState.selectedColorTheme.iconColor)
                            ),
                          ),
                          !pageState.logoImageSelected ? TextDandyLight(
                            type: TextDandyLight.BRAND_LOGO,
                            fontFamily: pageState.currentIconFont,
                            textAlign: TextAlign.center,
                            text: pageState.profile.businessName.substring(0, 1),
                            color: ColorConstants.hexToColor(pageState.selectedColorTheme.iconTextColor),
                          ) : SizedBox()
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      height: 48,
                      child: TextDandyLight(
                        textAlign: TextAlign.center,
                        type: TextDandyLight.LARGE_TEXT,
                        fontFamily: pageState.currentTitleFont,
                        text: 'Sample Title Text',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                      child: TextDandyLight(
                        textAlign: TextAlign.left,
                        type: TextDandyLight.MEDIUM_TEXT,
                        fontFamily: pageState.currentBodyFont,
                        text: 'This is a sample of what the body text will look like. This is a sample of what the body text will look like.',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if(!pageState.logoImageSelected) {
                            _showFontSelectionSheet(context, FontTheme.ICON_FONT_ID);
                        }
                      },
                      child: Container(
                        height: 54,
                        color: Color(ColorConstants.getPrimaryWhite()),
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextDandyLight(
                                textAlign: TextAlign.center,
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Icon font',
                                color: Color(pageState.logoImageSelected ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                              ),
                              Container(
                                height: 42,
                                padding: EdgeInsets.only(left: 24, right: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  color: Color(pageState.logoImageSelected ? ColorConstants.getPrimaryGreyLight() : ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                                child: TextDandyLight(
                                  textAlign: TextAlign.center,
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.currentIconFont,
                                  color: Color(pageState.logoImageSelected ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showFontSelectionSheet(context, FontTheme.TITLE_FONT_ID);
                      },
                      child: Container(
                        height: 54,
                        color: Color(ColorConstants.getPrimaryWhite()),
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextDandyLight(
                                textAlign: TextAlign.center,
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Title font',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                              Container(
                                height: 42,
                                padding: EdgeInsets.only(left: 24, right: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                                child: TextDandyLight(
                                  textAlign: TextAlign.center,
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.currentTitleFont,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showFontSelectionSheet(context, FontTheme.BODY_FONT_ID);
                      },
                      child: Container(
                        height: 54,
                        color: Color(ColorConstants.getPrimaryWhite()),
                        margin: EdgeInsets.only(left: 16, right: 16, bottom: 32),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextDandyLight(
                                textAlign: TextAlign.center,
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Body font',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                              Container(
                                height: 42,
                                padding: EdgeInsets.only(left: 24, right: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                                child: TextDandyLight(
                                  textAlign: TextAlign.center,
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.currentBodyFont,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            alignment: Alignment.center,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Reset fonts',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            alignment: Alignment.center,
                            height: 42,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Color(ColorConstants.getPeachDark())
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Save Font Theme',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 1,
                      width: double.infinity,
                      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showFontThemeSelectionSheet(context);
                      },
                      child: Container(
                        height: 56,
                        margin: EdgeInsets.only(left: 16, right: 8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                        ),
                        child: FontThemeWidget(),
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      );
}

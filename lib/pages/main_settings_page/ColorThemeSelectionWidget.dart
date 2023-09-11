import 'dart:ui';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../widgets/TextDandyLight.dart';

class ColorThemeSelectionWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ColorThemeSelectionWidgetState();
  }
}

class _ColorThemeSelectionWidgetState extends State<ColorThemeSelectionWidget> with TickerProviderStateMixin {
  Color tempSelectionColor = null;

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
                text: 'Color Theme',
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 48),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(ColorConstants.getPrimaryWhite())
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Icon color',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: '#' + ColorConstants.getHex(pageState.currentIconColor),
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tempSelectionColor = pageState.currentIconColor;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(150),
                                          topRight: Radius.circular(150),
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)
                                      )
                                  ),
                                  titlePadding: const EdgeInsets.all(0),
                                  contentPadding: const EdgeInsets.all(0),
                                  content: SingleChildScrollView(
                                    child: HueRingPicker(
                                      hueRingStrokeWidth: 30,
                                      pickerColor: pageState.currentIconColor,
                                      onColorChanged: (color) {
                                        setState(() {
                                          tempSelectionColor = color;
                                        });
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'CANCEL',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'SAVE',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        pageState.onColorSaved(tempSelectionColor, ColorConstants.icon);
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: pageState.currentIconColor,
                              border: Border.all(
                                width: 1,
                                color: ColorConstants.isWhite(pageState.currentIconColor) ? Color(ColorConstants.getPrimaryGreyMedium()) : pageState.currentIconColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Icon text color',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: '#' + ColorConstants.getHex(pageState.currentIconTextColor),
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tempSelectionColor = pageState.currentIconTextColor;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(150),
                                          topRight: Radius.circular(150),
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)
                                      )
                                  ),
                                  titlePadding: const EdgeInsets.all(0),
                                  contentPadding: const EdgeInsets.all(0),
                                  content: SingleChildScrollView(
                                    child: HueRingPicker(
                                      hueRingStrokeWidth: 22,
                                      pickerColor: pageState.currentIconTextColor,
                                      onColorChanged: (color) {
                                        setState(() {
                                          tempSelectionColor = color;
                                        });
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'CANCEL',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'SAVE',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        pageState.onColorSaved(tempSelectionColor, ColorConstants.iconText);
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: pageState.currentIconTextColor,
                              border: Border.all(
                                width: 1,
                                color: ColorConstants.isWhite(pageState.currentIconTextColor) ? Color(ColorConstants.getPrimaryGreyMedium()) : pageState.currentIconTextColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Button color',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: '#' + ColorConstants.getHex(pageState.currentButtonColor),
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tempSelectionColor = pageState.currentButtonColor;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(150),
                                          topRight: Radius.circular(150),
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)
                                      )
                                  ),
                                  titlePadding: const EdgeInsets.all(0),
                                  contentPadding: const EdgeInsets.all(0),
                                  content: SingleChildScrollView(
                                    child: HueRingPicker(
                                      hueRingStrokeWidth: 22,
                                      pickerColor: pageState.currentButtonColor,
                                      onColorChanged: (color) {
                                        setState(() {
                                          tempSelectionColor = color;
                                        });
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'CANCEL',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'SAVE',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        pageState.onColorSaved(tempSelectionColor, ColorConstants.button);
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: pageState.currentButtonColor,
                              border: Border.all(
                                width: 1,
                                color: ColorConstants.isWhite(pageState.currentButtonColor) ? Color(ColorConstants.getPrimaryGreyMedium()) : pageState.currentButtonColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Button text color',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: '#' + ColorConstants.getHex(pageState.currentButtonTextColor),
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tempSelectionColor = pageState.currentButtonTextColor;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(150),
                                          topRight: Radius.circular(150),
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)
                                      )
                                  ),
                                  titlePadding: const EdgeInsets.all(0),
                                  contentPadding: const EdgeInsets.all(0),
                                  content: SingleChildScrollView(
                                    child: HueRingPicker(
                                      hueRingStrokeWidth: 22,
                                      pickerColor: pageState.currentButtonTextColor,
                                      onColorChanged: (color) {
                                        setState(() {
                                          tempSelectionColor = color;
                                        });
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'CANCEL',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'SAVE',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        pageState.onColorSaved(tempSelectionColor, ColorConstants.buttonText);
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: pageState.currentButtonTextColor,
                              border: Border.all(
                                width: 1,
                                color: ColorConstants.isWhite(pageState.currentButtonTextColor) ? Color(ColorConstants.getPrimaryGreyMedium()) : pageState.currentButtonTextColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Banner color',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: '#' + ColorConstants.getHex(pageState.currentBannerColor),
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tempSelectionColor = pageState.currentBannerColor;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(150),
                                          topRight: Radius.circular(150),
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)
                                      )
                                  ),
                                  titlePadding: const EdgeInsets.all(0),
                                  contentPadding: const EdgeInsets.all(0),
                                  content: SingleChildScrollView(
                                    child: HueRingPicker(
                                      hueRingStrokeWidth: 22,
                                      pickerColor: pageState.currentBannerColor,
                                      onColorChanged: (color) {
                                        setState(() {
                                          tempSelectionColor = color;
                                        });
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'CANCEL',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: TextDandyLight(
                                        textAlign: TextAlign.center,
                                        text: 'SAVE',
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      onPressed: () {
                                        pageState.onColorSaved(tempSelectionColor, ColorConstants.banner);
                                        setState(() {
                                          tempSelectionColor = null;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: pageState.currentBannerColor,
                              border: Border.all(
                                width: 1,
                                color: ColorConstants.isWhite(pageState.currentBannerColor) ? Color(ColorConstants.getPrimaryGreyMedium()) : pageState.currentBannerColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

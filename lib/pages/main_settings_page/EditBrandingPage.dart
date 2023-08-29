import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/pages/main_settings_page/SaveColorThemeBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';

import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/DandyLightPainter.dart';
import '../../widgets/TextDandyLight.dart';
import 'ColorThemeSelectionBottomSheet.dart';
import 'ColorThemeWidget.dart';
import 'FontThemeSelectionBottomSheet.dart';
import 'FontThemeWidget.dart';
import 'PreviewOptionsBottomSheet.dart';

class EditBrandingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _EditBrandingPageState();
  }
}

class _EditBrandingPageState extends State<EditBrandingPage> with TickerProviderStateMixin {
  bool loading = false;
  final List<ColorLabelType> _labelTypes = [ColorLabelType.hsl, ColorLabelType.hsv];
  final List<Color> colorHistory = [];
  Color tempSelectionColor = null;

  void _showColorThemeSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return ColorThemeSelectionBottomSheet();
      },
    );
  }

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

  void _showSaveColorThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SaveColorThemeBottomSheet();
      },
    );
  }

  void _showPreviewOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return PreviewOptionsBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
        onInit: (store) {

        },
        converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
          body: Container(
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                  pinned: true,
                  centerTitle: true,
                  elevation: 2.0,
                  title: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: "Branding",
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  actions: [
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          _showPreviewOptionsBottomSheet(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          alignment: Alignment.center,
                          height: 56,
                          width: 100,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Preview',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                    ),
                    ),
                  ]
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                          Container(
                              margin: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      _showPreviewOptionsBottomSheet(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 8, bottom: 32),
                                      width: 200,
                                      alignment: Alignment.center,
                                      height: 42,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          color: Color(ColorConstants.getPeachDark())
                                      ),
                                      child: TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Preview Brand',
                                        textAlign: TextAlign.center,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    alignment: Alignment.center,
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Logo',
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  Container(
                                    height: 324,
                                    margin: EdgeInsets.only(bottom: 48),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Color(ColorConstants.getPrimaryWhite())
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              pageState.resizedLogoImage != null ? Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: pageState.logoImageSelected ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPrimaryWhite())
                                                        )
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(bottom: 8),
                                                          child: TextDandyLight(
                                                            type: TextDandyLight.SMALL_TEXT,
                                                            text: 'Image',
                                                            textAlign: TextAlign.center,
                                                            color: Color(pageState.logoImageSelected ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryGreyMedium()),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            pageState.onLogoImageSelected(true);
                                                          },
                                                          child: Container(
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius: new BorderRadius.circular(58.0),
                                                                  child: Image(
                                                                    fit: BoxFit.cover,
                                                                    width: 116,
                                                                    height: 116,
                                                                    image: FileImage(File(pageState.resizedLogoImage.path)),
                                                                  ),
                                                                ),
                                                                !pageState.logoImageSelected ? ClipRRect(
                                                                  borderRadius: new BorderRadius.circular(58.0),
                                                                  child: Image(
                                                                    fit: BoxFit.cover,
                                                                    color: Color(ColorConstants.getPrimaryGreyMedium()).withOpacity(.8),
                                                                    width: 116,
                                                                    height: 116,
                                                                    image: pageState.profile.logoUrl != null && pageState.profile.logoUrl.isNotEmpty && pageState.resizedLogoImage == null
                                                                        ? DandyLightNetworkImage(pageState.profile.logoUrl) : FileImage(File(pageState.resizedLogoImage.path)),
                                                                  ),
                                                                ) : SizedBox()
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState((){
                                                              loading = true;
                                                            });
                                                            getDeviceImage(pageState);
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(top: 8),
                                                            child: TextDandyLight(
                                                              type: TextDandyLight.SMALL_TEXT,
                                                              textAlign: TextAlign.center,
                                                              text: 'New Image',
                                                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 8),
                                                    child: TextDandyLight(
                                                      type: TextDandyLight.SMALL_TEXT,
                                                      text: 'Selected',
                                                      textAlign: TextAlign.center,
                                                      color: Color(pageState.logoImageSelected ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryWhite()),
                                                    ),
                                                  ),
                                                ],
                                              ) : Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 10, top: 8),
                                                    child: TextDandyLight(
                                                      type: TextDandyLight.SMALL_TEXT,
                                                      text: 'Image',
                                                      textAlign: TextAlign.center,
                                                      color: Color(ColorConstants.getPrimaryBlack()),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState((){
                                                        loading = true;
                                                      });
                                                      getDeviceImage(pageState);
                                                    },
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.center,
                                                          height: 116,
                                                          width: 116,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Color(ColorConstants.getPrimaryWhite())
                                                          ),
                                                        ),
                                                        CustomPaint(
                                                          size: Size(116, 116),
                                                          foregroundPainter: DandyLightPainter(
                                                              completeColor: Color(ColorConstants.getPrimaryGreyMedium()),
                                                              width: 2),
                                                        ),
                                                        loading ? LoadingAnimationWidget.fourRotatingDots(
                                                          color: Color(ColorConstants.getPeachDark()),
                                                          size: 32,
                                                        ) : Container(
                                                          child: TextDandyLight(
                                                            type: TextDandyLight.MEDIUM_TEXT,
                                                            textAlign: TextAlign.center,
                                                            text: 'Upload\nimage',
                                                            color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 8),
                                                    child: TextDandyLight(
                                                      type: TextDandyLight.SMALL_TEXT,
                                                      text: '( .jpg or .png )',
                                                      textAlign: TextAlign.center,
                                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 84),
                                                child: TextDandyLight(
                                                  type: TextDandyLight.MEDIUM_TEXT,
                                                  text: 'OR',
                                                  color: Color(ColorConstants.getPrimaryBlack()),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 32),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: !pageState.logoImageSelected ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPrimaryWhite())
                                                        )
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        pageState.onLogoImageSelected(false);
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(bottom: 8),
                                                            child: TextDandyLight(
                                                              type: TextDandyLight.SMALL_TEXT,
                                                              text: 'Icon',
                                                              textAlign: TextAlign.center,
                                                              color: Color(!pageState.logoImageSelected ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryGreyMedium()),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.center,
                                                            height: 116,
                                                            width: 116,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Color(pageState.logoImageSelected ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPeachDark())
                                                            ),
                                                            child: TextDandyLight(
                                                              type: TextDandyLight.BRAND_LOGO,
                                                              text: pageState.profile.businessName.substring(0, 1),
                                                              color: Color(ColorConstants.getPrimaryWhite()),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 8),
                                                    child: TextDandyLight(
                                                      type: TextDandyLight.SMALL_TEXT,
                                                      text: 'Selected',
                                                      textAlign: TextAlign.center,
                                                      color: Color(!pageState.logoImageSelected ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryWhite()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 32, left: 32, right: 32),
                                          child: TextDandyLight(
                                            type: TextDandyLight.SMALL_TEXT,
                                            text: 'The selected logo/icon will be used to brand your client portal and documents.',
                                            textAlign: TextAlign.center,
                                            color: Color(ColorConstants.getPrimaryBlack()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                                            hueRingStrokeWidth: 22,
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                pageState.onResetColors();
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
                                                  text: 'Reset colors',
                                                  textAlign: TextAlign.center,
                                                  color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if(pageState.saveColorThemeEnabled) {
                                                  _showSaveColorThemeBottomSheet(context);
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(left: 16, right: 16),
                                                alignment: Alignment.center,
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: Color(pageState.saveColorThemeEnabled ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryGreyMedium())
                                                ),
                                                child: TextDandyLight(
                                                  type: TextDandyLight.MEDIUM_TEXT,
                                                  text: 'Save Color Theme',
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
                                            _showColorThemeSelectionSheet(context);
                                          },
                                          child: Container(
                                            height: 56,
                                            margin: EdgeInsets.only(left: 16, right: 8),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                                            ),
                                            child: ColorThemeWidget(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                                        Container(
                                          margin: EdgeInsets.only(top: 24),
                                          alignment: Alignment.center,
                                          height: 116,
                                          width: 116,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(ColorConstants.getPeachDark())
                                          ),
                                          child: TextDandyLight(
                                            type: TextDandyLight.BRAND_LOGO,
                                            text: pageState.profile.businessName.substring(0, 1),
                                            color: Color(ColorConstants.getPrimaryWhite()),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                          height: 48,
                                          child: TextDandyLight(
                                            textAlign: TextAlign.center,
                                            type: TextDandyLight.LARGE_TEXT,
                                            text: 'Sample Title Text',
                                            color: Color(ColorConstants.getPrimaryBlack()),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                                          child: TextDandyLight(
                                            textAlign: TextAlign.left,
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'This is a sample of what the body text will look like. This is a sample of what the body text will look like.',
                                            color: Color(ColorConstants.getPrimaryBlack()),
                                          ),
                                        ),
                                        Container(
                                          height: 54,
                                          margin: EdgeInsets.only(left: 16, right: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextDandyLight(
                                                textAlign: TextAlign.center,
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Icon font',
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
                                                  text: 'Sans Serif',
                                                  color: Color(ColorConstants.getPrimaryBlack()),
                                                ),
                                              ),
                                            ]
                                          ),
                                        ),
                                        Container(
                                          height: 54,
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
                                                    text: 'Sans Serif',
                                                    color: Color(ColorConstants.getPrimaryBlack()),
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ),
                                        Container(
                                          height: 54,
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
                                                    text: 'Sans Serif',
                                                    color: Color(ColorConstants.getPrimaryBlack()),
                                                  ),
                                                ),
                                              ]
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
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future getDeviceImage(MainSettingsPageState pageState) async {
    try{
      XFile localImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(localImage == null) {
        setState((){
          loading = false;
        });
      } else {
        pageState.onLogoUploaded(localImage);
      }
    } catch(ex) {
      print(ex.toString());
    }
  }
}

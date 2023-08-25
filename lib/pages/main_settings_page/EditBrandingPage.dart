import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/common_widgets/LoginTextField.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../utils/Shadows.dart';
import '../../widgets/DandyLightPainter.dart';
import '../../widgets/TextDandyLight.dart';
import 'ColorThemeSelectionBottomSheet.dart';
import 'ColorThemeWidget.dart';

class EditBrandingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _EditBrandingPageState();
  }
}

class _EditBrandingPageState extends State<EditBrandingPage>
    with TickerProviderStateMixin {

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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
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
                                    height: 300,
                                    margin: EdgeInsets.only(bottom: 32),
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
                                              Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 8),
                                                    child: TextDandyLight(
                                                      type: TextDandyLight.SMALL_TEXT,
                                                      text: 'Image',
                                                      textAlign: TextAlign.center,
                                                      color: Color(ColorConstants.getPrimaryBlack()),
                                                    ),
                                                  ),
                                                  Stack(
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
                                                        child: TextDandyLight(
                                                          type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                                                          text: pageState.profile.businessName.substring(0, 1),
                                                          color: Color(ColorConstants.getPrimaryWhite()),
                                                        ),
                                                      ),
                                                      CustomPaint(
                                                        size: Size(116, 116),
                                                        foregroundPainter: DandyLightPainter(
                                                            completeColor: Color(ColorConstants.getPrimaryGreyMedium()),
                                                            width: 2),
                                                      ),
                                                      Container(
                                                        child: TextDandyLight(
                                                          type: TextDandyLight.MEDIUM_TEXT,
                                                          textAlign: TextAlign.center,
                                                          text: 'Upload\nimage',
                                                          color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 8),
                                                    child: TextDandyLight(
                                                      type: TextDandyLight.SMALL_TEXT,
                                                      text: '150 x 150\n( .jpg or .png )',
                                                      textAlign: TextAlign.center,
                                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 72),
                                                child: TextDandyLight(
                                                  type: TextDandyLight.MEDIUM_TEXT,
                                                  text: 'OR',
                                                  color: Color(ColorConstants.getPrimaryBlack()),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 8),
                                                    child: TextDandyLight(
                                                      type: TextDandyLight.SMALL_TEXT,
                                                      text: 'Icon',
                                                      textAlign: TextAlign.center,
                                                      color: Color(ColorConstants.getPrimaryBlack()),
                                                    ),
                                                  ),
                                                  Container(
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
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 32, left: 32, right: 32),
                                          child: TextDandyLight(
                                            type: TextDandyLight.SMALL_TEXT,
                                            text: 'The selected logo/icon will be used to brand your client portal and documents',
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
                                    margin: EdgeInsets.only(bottom: 32),
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
                                                    text: 'Banner color',
                                                    textAlign: TextAlign.center,
                                                    color: Color(ColorConstants.getPrimaryBlack()),
                                                  ),
                                                  TextDandyLight(
                                                    type: TextDandyLight.SMALL_TEXT,
                                                    text: '#f34uyg',
                                                    textAlign: TextAlign.center,
                                                    color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 42,
                                                width: 42,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(24),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Color(ColorConstants.getPrimaryBackgroundGrey())
                                                  ),
                                                  color: Color(ColorConstants.getBlueDark())
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
                                                    text: '#f34uyg',
                                                    textAlign: TextAlign.center,
                                                    color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 42,
                                                width: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: Color(ColorConstants.getPeachDark()),
                                                    border: Border.all(
                                                    width: 1,
                                                    color: Color(ColorConstants.getPrimaryBackgroundGrey()),
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
                                                    text: '#f34uyg',
                                                    textAlign: TextAlign.center,
                                                    color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 42,
                                                width: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Color(ColorConstants.getPrimaryBackgroundGrey())
                                                    ),
                                                    color: Color(ColorConstants.getPrimaryWhite())
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
                                                    text: 'Icon color',
                                                    textAlign: TextAlign.center,
                                                    color: Color(ColorConstants.getPrimaryBlack()),
                                                  ),
                                                  TextDandyLight(
                                                    type: TextDandyLight.SMALL_TEXT,
                                                    text: '#f34uyg',
                                                    textAlign: TextAlign.center,
                                                    color: Color(ColorConstants.getPrimaryGreyMedium()),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 42,
                                                width: 42,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Color(ColorConstants.getPrimaryBackgroundGrey())
                                                    ),
                                                    color: Color(ColorConstants.getPeachDark())
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

                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(left: 32, right: 32),
                                                alignment: Alignment.center,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                                child: TextDandyLight(
                                                  type: TextDandyLight.SMALL_TEXT,
                                                  text: 'Reset colors',
                                                  textAlign: TextAlign.center,
                                                  color: Color(ColorConstants.getPeachDark()),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {

                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(left: 32, right: 32),
                                                alignment: Alignment.center,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: Color(ColorConstants.getPeachDark())
                                                ),
                                                child: TextDandyLight(
                                                  type: TextDandyLight.SMALL_TEXT,
                                                  text: 'Save Theme',
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
}

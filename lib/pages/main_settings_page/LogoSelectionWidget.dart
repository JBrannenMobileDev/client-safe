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
import 'FontThemeSelectionBottomSheet.dart';
import 'FontThemeWidget.dart';
import 'PreviewOptionsBottomSheet.dart';

class LogoSelectionWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LogoSelectionWidgetState();
  }
}

class _LogoSelectionWidgetState extends State<LogoSelectionWidget> with TickerProviderStateMixin {
  bool loading = false;

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
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 116,
                                          width: 116,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: pageState.logoImageSelected ? Color( ColorConstants.getPrimaryGreyMedium()) :  ColorConstants.hexToColor(pageState.selectedColorTheme.iconColor)
                                          ),
                                        ),
                                        TextDandyLight(
                                          type: TextDandyLight.BRAND_LOGO,
                                          fontFamily: pageState.currentIconFont,
                                          textAlign: TextAlign.center,
                                          text: pageState.profile.businessName.substring(0, 1),
                                          color: ColorConstants.hexToColor(pageState.selectedColorTheme.iconTextColor),
                                        )
                                      ],
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
            )
          ],
        ),
      );

  Future getDeviceImage(MainSettingsPageState pageState) async {
    try{
      XFile localImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      CroppedFile croppedImage = await ImageCropper().cropImage(
        sourcePath: localImage.path,
        maxWidth: 300,
        maxHeight: 300,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        cropStyle: CropStyle.circle,
      );
      localImage = XFile(croppedImage.path);
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

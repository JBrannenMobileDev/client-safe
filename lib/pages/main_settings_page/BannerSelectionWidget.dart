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

class BannerSelectionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BannerSelectionWidgetState();
  }
}

class _BannerSelectionWidgetState extends State<BannerSelectionWidget> with TickerProviderStateMixin {
  bool loading = false;
  List<bool> selections = List.generate(2, (index) => index == 1 ? true : false);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
        onInit: (store) {
          store.dispatch(ClearBrandingStateAction(
              store.state.mainSettingsPageState,
              store.state.mainSettingsPageState.profile));
        },
        converter: (Store<AppState> store) =>
            MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) =>
            Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              alignment: Alignment.center,
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Client Portal Banner',
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Container(
              height: 342,
              margin: EdgeInsets.only(bottom: 132),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)
                  ),
                  color: Color(ColorConstants.getPrimaryWhite())),
              child: Column(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          getDeviceImage(pageState);
                        },
                        child: pageState.logoImageSelected ? Container(
                          child: pageState.resizedLogoImage != null ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                new BorderRadius.circular(16),
                                child: Image(
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 164,
                                  image: FileImage(File(pageState.resizedLogoImage.path)),
                                ),
                              )
                            ],
                          ) : Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 164,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(ColorConstants.getPrimaryWhite())),
                              ),
                              CustomPaint(
                                size: Size(164, double.infinity),
                                foregroundPainter: DandyLightPainter(
                                    completeColor: Color(ColorConstants.getPrimaryGreyMedium()),
                                    width: 2
                                ),
                              ),
                              loading ? LoadingAnimationWidget.fourRotatingDots(
                                color: Color(ColorConstants.getPeachDark()),
                                size: 48,
                              )
                                  : Container(
                                child: TextDandyLight(
                                  type: TextDandyLight
                                      .MEDIUM_TEXT,
                                  textAlign: TextAlign.center,
                                  text: 'Upload\nimage\n( .jpg or .png )',
                                  color: Color(ColorConstants
                                      .getPrimaryGreyMedium()),
                                ),
                              ),
                            ],
                          ),
                        )
                            : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 164,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                                  color: pageState.logoImageSelected
                                      ? Color(ColorConstants
                                      .getPrimaryGreyMedium())
                                      : ColorConstants.hexToColor(
                                      pageState
                                          .selectedColorTheme
                                          .iconColor)),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.BRAND_LOGO,
                              fontFamily: pageState.currentIconFont,
                              textAlign: TextAlign.center,
                              text: pageState.profile.businessName
                                  .substring(0, 1),
                              color: ColorConstants.hexToColor(
                                  pageState.selectedColorTheme
                                      .iconTextColor),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      ToggleButtons(
                        children: [
                          Container(
                            width: 132,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Image',
                              textAlign: TextAlign.center,
                              color: Color(selections.elementAt(0) ? ColorConstants.getPrimaryWhite() : ColorConstants.getPeachDark()),
                            ),
                          ),
                          Container(
                            width: 132,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Solid Color',
                              textAlign: TextAlign.center,
                              color: Color(selections.elementAt(1) ? ColorConstants.getPrimaryWhite() : ColorConstants.getPeachDark()),
                            ),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(24),
                        borderColor: Color(ColorConstants.getPeachDark()),
                        selectedBorderColor: Color(ColorConstants.getPeachDark()),
                        fillColor: Color(ColorConstants.getPeachDark()),
                        isSelected: selections,
                        onPressed: (index) {
                            setState(() {
                              if(index == 0) {
                                selections[0] = true;
                                selections[1] = false;
                                pageState.onBannerImageSelected(true);
                              } else {
                                selections[1] = true;
                                selections[0] = false;
                                pageState.onBannerImageSelected(false);
                              }
                            });
                        },
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 32, left: 32, right: 32),
                    child: TextDandyLight(
                      type: TextDandyLight.SMALL_TEXT,
                      text: 'The selected banner will be used to brand your client portal and documents.',
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
    try {
      XFile localImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      CroppedFile croppedImage = await ImageCropper().cropImage(
        sourcePath: localImage.path,
        maxWidth: 1920,
        maxHeight: 300,
        aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1.3),
        cropStyle: CropStyle.rectangle,
      );
      localImage = XFile(croppedImage.path);
      if (localImage == null) {
        setState(() {
          loading = false;
        });
      } else {
        pageState.onBannerUploaded(localImage);
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}

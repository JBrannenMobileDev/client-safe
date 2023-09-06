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

import '../../models/ColorTheme.dart';
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
                        child: Stack(
                          children: [
                            pageState.bannerImageSelected && pageState.resizedBannerImage != null ? ClipRRect(
                              borderRadius: new BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16)
                              ),
                              child: Image(
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 164,
                                image: FileImage(File(pageState.resizedBannerImage.path)),
                              ),
                            ) : Container(
                              alignment: Alignment.center,
                              height: 164,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorConstants.hexToColor(pageState.selectedColorTheme.bannerColor),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16)
                                ),
                              ),
                            ),
                            !pageState.bannerImageSelected ? Container(
                              alignment: Alignment.center,
                              height: 164,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorConstants.hexToColor(pageState.selectedColorTheme.bannerColor),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16)
                                ),
                              ),
                            ) : SizedBox(),
                            pageState.bannerImageSelected && pageState.resizedBannerImage == null ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/images/icons/file_upload.png',
                                    color: ColorConstants.isWhite(ColorConstants.hexToColor(pageState.selectedColorTheme.bannerColor)) ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPrimaryWhite()),
                                    width: 48,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 164,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    fontFamily: pageState.currentTitleFont,
                                    textAlign: TextAlign.center,
                                    text: 'Upload Banner Image',
                                    color: ColorConstants.isWhite(ColorConstants.hexToColor(pageState.selectedColorTheme.bannerColor)) ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPrimaryWhite()),
                                  ),
                                ),
                              ],
                            ) : Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  height: 164,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 32),
                                  child: pageState.logoImageSelected && pageState.resizedLogoImage != null ? ClipRRect(
                                    borderRadius:
                                    new BorderRadius.circular(82.0),
                                    child: Image(
                                      fit: BoxFit.cover,
                                      width: 72,
                                      height: 72,
                                      image: FileImage(File(pageState.resizedLogoImage.path)),
                                    ),
                                  ) : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 72,
                                        width: 72,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: ElevationToShadow[4],
                                            color: pageState.logoImageSelected
                                                ? Color(ColorConstants
                                                .getPrimaryGreyMedium())
                                                : ColorConstants.hexToColor(
                                                pageState
                                                    .selectedColorTheme
                                                    .iconColor)),
                                      ),
                                      TextDandyLight(
                                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                                          fontFamily: pageState.currentIconFont,
                                          textAlign: TextAlign.center,
                                          text: pageState.logoCharacter
                                              .substring(0, 1),
                                          color: ColorConstants.hexToColor(
                                              pageState.selectedColorTheme
                                                  .iconTextColor),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      fontFamily: pageState.currentTitleFont,
                                      textAlign: TextAlign.center,
                                      text: pageState.profile.businessName,
                                      addShadow: true,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      fontFamily: pageState.currentTitleFont,
                                      textAlign: TextAlign.center,
                                      text: 'Client Name',
                                      addShadow: true,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    )
                                  ],
                                )
                              ],
                            ),
                            pageState.bannerImageSelected && pageState.resizedBannerImage != null ? Container(
                              alignment: Alignment.topRight,
                              width: double.infinity,
                              padding: EdgeInsets.only(top: 16, right: 16),
                              child: Image.asset(
                                'assets/images/icons/select_photo.png',
                                color: Color(ColorConstants.getPrimaryWhite()),
                                width: 32,
                              ),
                            ) : SizedBox(),
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
                              color: selections.elementAt(0) ? pageState.currentButtonTextColor : pageState.currentButtonColor,
                            ),
                          ),
                          Container(
                            width: 132,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Solid Color',
                              textAlign: TextAlign.center,
                              color: selections.elementAt(1) ? pageState.currentButtonTextColor : pageState.currentButtonColor,
                            ),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(24),
                        borderColor: pageState.currentButtonColor,
                        selectedBorderColor: pageState.currentButtonColor,
                        fillColor: pageState.currentButtonColor,
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
        setState(() {
          loading = false;
        });
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}

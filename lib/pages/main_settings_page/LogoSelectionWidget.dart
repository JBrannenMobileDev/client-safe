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
import 'ChangeIconLetterBottomSheet.dart';
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
  List<bool> selections = List.generate(2, (index) => index == 1 ? true : false);
  List<bool> shapeSelections = List.generate(2, (index) => index == 0 ? true : false);

  void _showChangeLetterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return ChangeIconLetterBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
        onInit: (store) {
          store.dispatch(ClearBrandingStateAction(
              store.state.mainSettingsPageState,
              store.state.mainSettingsPageState.profile));
          if(store.state.mainSettingsPageState.profile.logoSelected) {
            selections[0] = true;
            selections[1] = false;
          } else {
            selections[1] = true;
            selections[0] = false;
          }
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
                text: 'Logo',
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Container(
              height: 432,
              margin: EdgeInsets.only(bottom: 48),
              padding: EdgeInsets.only(top: 32),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      topRight: Radius.circular(MediaQuery.of(context).size.width/2),
                      topLeft: Radius.circular(MediaQuery.of(context).size.width/2)
                  ),
                  color: Color(ColorConstants.getPrimaryWhite())),
              child: Column(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(pageState.logoImageSelected) {
                            setState(() {
                              loading = true;
                            });
                            getDeviceImage(pageState);
                          } else {
                            _showChangeLetterBottomSheet(context);
                          }
                        },
                        child: pageState.logoImageSelected ? Container(
                          child: pageState.resizedLogoImage != null ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                new BorderRadius.circular(82.0),
                                child: Image(
                                  fit: BoxFit.cover,
                                  width: 164,
                                  height: 164,
                                  image: FileImage(File(pageState.resizedLogoImage.path)),
                                ),
                              )
                            ],
                          ) : pageState.profile.logoUrl != null && pageState.profile.logoUrl.isNotEmpty ? ClipRRect(
                            borderRadius:
                            new BorderRadius.circular(82.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: pageState.currentIconColor,
                              ),
                              width: 164,
                              height: 164,
                              child: DandyLightNetworkImage(
                                pageState.profile.logoUrl,
                                color: pageState.currentIconColor,
                              )
                            ),
                          ) : Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 164,
                                width: 164,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(ColorConstants.getPrimaryWhite())),
                              ),
                              CustomPaint(
                                size: Size(164, 164),
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
                              width: 164,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
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
                              text: pageState.logoCharacter
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
                              color: selections.elementAt(0) ? ColorConstants.hexToColor(pageState.selectedColorTheme.buttonTextColor) : ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                            ),
                          ),
                          Container(
                            width: 132,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Solid Color',
                              textAlign: TextAlign.center,
                              color: selections.elementAt(1) ? ColorConstants.hexToColor(pageState.selectedColorTheme.buttonTextColor) : ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                            ),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(24),
                        borderColor: ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                        selectedBorderColor: ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                        fillColor: ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                        isSelected: selections,
                        onPressed: (index) {
                            setState(() {
                              if(index == 0) {
                                selections[0] = true;
                                selections[1] = false;
                                pageState.onLogoImageSelected(true);
                              } else {
                                selections[1] = true;
                                selections[0] = false;
                                pageState.onLogoImageSelected(false);
                              }
                            });
                        },
                      ),
                      SizedBox(height: 16),
                      ToggleButtons(
                        children: [
                          Container(
                            width: 132,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Circle',
                              textAlign: TextAlign.center,
                              color: shapeSelections.elementAt(0) ? ColorConstants.hexToColor(pageState.selectedColorTheme.buttonTextColor) : ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                            ),
                          ),
                          Container(
                            width: 132,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Square',
                              textAlign: TextAlign.center,
                              color: shapeSelections.elementAt(1) ? ColorConstants.hexToColor(pageState.selectedColorTheme.buttonTextColor) : ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                            ),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(24),
                        borderColor: ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                        selectedBorderColor: ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                        fillColor: ColorConstants.hexToColor(pageState.selectedColorTheme.buttonColor),
                        isSelected: shapeSelections,
                        onPressed: (index) {
                          setState(() {
                            if(index == 0) {
                              shapeSelections[0] = true;
                              shapeSelections[1] = false;
                              // pageState.onLogoImageSelected(true);
                            } else {
                              shapeSelections[1] = true;
                              shapeSelections[0] = false;
                              // pageState.onLogoImageSelected(false);
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
                      text:
                          'The selected logo/icon will be used to brand your client portal and documents.',
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
      XFile localImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      CroppedFile croppedImage = await ImageCropper().cropImage(
        sourcePath: localImage.path,
        maxWidth: 300,
        maxHeight: 300,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        cropStyle: CropStyle.circle,
      );
      localImage = XFile(croppedImage.path);
      if (localImage == null) {
        setState(() {
          loading = false;
        });
      } else {
        pageState.onLogoUploaded(localImage);
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}

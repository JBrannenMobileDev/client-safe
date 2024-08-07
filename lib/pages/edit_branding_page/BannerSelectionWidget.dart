import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import 'EditBrandingPageState.dart';

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
      StoreConnector<AppState, EditBrandingPageState>(
        onInit: (store) async {
          if(store.state.dashboardPageState!.profile!.bannerImageSelected!) {
            selections[0] = true;
            selections[1] = false;
          } else {
            selections[1] = true;
            selections[0] = false;
          }
        },
        converter: (Store<AppState> store) =>
            EditBrandingPageState.fromStore(store),
        builder: (BuildContext context, EditBrandingPageState pageState) =>
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
              height: 332,
              margin: EdgeInsets.only(bottom: 164),
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
                            pageState.bannerImageSelected! ? pageState.bannerImage != null ? ClipRRect(
                              borderRadius: new BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16)
                              ),
                              child: Image(
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 164,
                                image: FileImage(File(pageState.bannerImage!.path)),
                              ),
                            ) : pageState.profile!.bannerMobileUrl != null ? Container(
                              height: 164,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16),
                                ),
                                child: DandyLightNetworkImage(
                                  pageState.profile!.bannerMobileUrl ?? '',
                                  color: pageState.currentBannerColor!,
                                  borderRadius: 0,
                                ),
                              ),
                            ) : Container(
                              alignment: Alignment.center,
                              height: 164,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: pageState.currentBannerColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16)
                                ),
                              ),
                            ) : SizedBox(),
                            !pageState.bannerImageSelected! ? Container(
                              alignment: Alignment.center,
                              height: 164,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: pageState.currentBannerColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16)
                                ),
                              ),
                            ) : SizedBox(),
                            pageState.bannerImageSelected! && pageState.bannerImage == null && pageState.profile!.bannerMobileUrl == null ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/images/icons/file_upload.png',
                                    color: ColorConstants.isWhite(pageState.currentBannerColor!) ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPrimaryWhite()),
                                    width: 48,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 164,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    fontFamily: pageState.currentFont,
                                    textAlign: TextAlign.center,
                                    text: 'Upload Banner Image',
                                    color: ColorConstants.isWhite(pageState.currentBannerColor!) ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPrimaryWhite()),
                                  ),
                                ),
                              ],
                            ) : SizedBox(),
                            pageState.bannerImageSelected! && (pageState.bannerImage != null || pageState.profile!.bannerMobileUrl != null && pageState.profile!.bannerMobileUrl!.isNotEmpty) ? Container(
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
                                pageState.onBannerImageSelected!(true);
                                EventSender().sendEvent(eventName: EventNames.BRANDING_BANNER_IMAGE_SELECTED);
                              } else {
                                selections[1] = true;
                                selections[0] = false;
                                pageState.onBannerImageSelected!(false);
                                EventSender().sendEvent(eventName: EventNames.BRANDING_BANNER_COLOR_SELECTED);
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

  Future getDeviceImage(EditBrandingPageState pageState) async {
    try {
      XFile? localImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(localImage != null) {
        XFile localWebImage = XFile((await CropImageForWeb(localImage.path))!.path);
        XFile localMobileImage = XFile((await CropImageForMobile(localImage.path))!.path);

        pageState.onBannerWebUploaded!(localWebImage);
        pageState.onBannerMobileUploaded!(localMobileImage);
        pageState.onBannerUploaded!(localImage);
        EventSender().sendEvent(eventName: EventNames.BRANDING_BANNER_IMAGE_UPLOADED);
        setState(() {
          loading = false;
        });
      }
    } catch (ex) {
      print(ex.toString());
      DandyToastUtil.showErrorToast('Image not loaded');
    }
  }

  Future<CroppedFile?> CropImageForWeb(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: 1920,
      maxHeight: 500,
      aspectRatio: CropAspectRatio(ratioX: 3.8, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop to fit desktop',
            lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop to fit desktop',
          aspectRatioPickerButtonHidden: true,
          doneButtonTitle: 'Next',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
  }

  Future<CroppedFile?> CropImageForMobile(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: 1080, //1080
      maxHeight: 810, //8// 10
      aspectRatio: CropAspectRatio(ratioX: 1.33, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop to fit mobile',
            lockAspectRatio: true,
        ),
        IOSUiSettings(
            title: 'Crop to fit mobile',
            aspectRatioPickerButtonHidden: true,
            doneButtonTitle: 'Save',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
        ),
      ],
    );
  }
}

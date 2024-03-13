import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../utils/UidUtil.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import 'EditBrandingPageState.dart';
import 'FontSelectionBottomSheet.dart';

class FontThemeSelectionWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FontThemeSelectionWidgetState();
  }
}

class _FontThemeSelectionWidgetState extends State<FontThemeSelectionWidget> with TickerProviderStateMixin {

  void _showFontSelectionSheet(BuildContext context, String id) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return FontSelectionBottomSheet(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, EditBrandingPageState>(
        converter: (Store<AppState> store) => EditBrandingPageState.fromStore(store),
        builder: (BuildContext context, EditBrandingPageState pageState) => Column(
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
                margin: EdgeInsets.only(bottom: 48),
                padding: EdgeInsets.only(bottom: 16),
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
                          pageState.logoImageSelected! ? pageState.resizedLogoImage != null ? ClipRRect(
                            borderRadius: new BorderRadius.circular(82.0),
                            child: Image(
                              fit: BoxFit.cover,
                              width: 164,
                              height: 164,
                              image: FileImage(File(pageState.resizedLogoImage!.path)),
                            ),
                          ) : ClipRRect(
                              borderRadius: new BorderRadius.circular(82.0),
                              child: Container(
                              alignment: Alignment.center,
                              height: 164,
                              width: 164,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: pageState.currentIconColor
                              ),
                              child: DandyLightNetworkImage(
                                pageState.profile!.logoUrl!
                              )
                            )
                          ) : Container(
                            alignment: Alignment.center,
                            height: 164,
                            width: 164,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: pageState.currentIconColor,
                            ),
                          ),
                          !pageState.logoImageSelected! ? TextDandyLight(
                            type: TextDandyLight.BRAND_LOGO,
                            fontFamily: pageState.currentIconFont,
                            textAlign: TextAlign.center,
                            text: pageState.logoCharacter,
                            color: pageState.currentIconTextColor,
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
                        fontFamily: pageState.currentFont,
                        text: 'Sample Title Text',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                      child: TextDandyLight(
                        textAlign: TextAlign.left,
                        type: TextDandyLight.MEDIUM_TEXT,
                        fontFamily: pageState.currentFont,
                        text: 'This is a sample of what the body text will look like. This is a sample of what the body text will look like.',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showFontSelectionSheet(context, FontTheme.ICON_FONT_ID);
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
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                              Container(
                                height: 42,
                                width: 184,
                                padding: EdgeInsets.only(left: 24, right: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                                child: TextDandyLight(
                                  textAlign: TextAlign.center,
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.currentIconFont,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showFontSelectionSheet(context, FontTheme.MAIN_FONT_ID);
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
                                text: 'Main font',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                              Container(
                                height: 42,
                                width: 184,
                                padding: EdgeInsets.only(left: 24, right: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                ),
                                child: TextDandyLight(
                                  textAlign: TextAlign.center,
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.currentFont,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      );
}

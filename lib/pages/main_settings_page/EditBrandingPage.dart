import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../utils/Shadows.dart';
import '../../widgets/TextDandyLight.dart';
import 'ColorThemeSelectionWidget.dart';
import 'FontThemeSelectionWidget.dart';
import 'LogoSelectionWidget.dart';
import 'PreviewOptionsBottomSheet.dart';

class EditBrandingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _EditBrandingPageState();
  }
}

class _EditBrandingPageState extends State<EditBrandingPage> with TickerProviderStateMixin {

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
          store.dispatch(ClearBrandingStateAction(store.state.mainSettingsPageState, store.state.mainSettingsPageState.profile));
        },
        converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
          body: Stack(
            children: [
              Container(
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
                                LogoSelectionWidget(),
                                ColorThemeSelectionWidget(),
                                FontThemeSelectionWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pageState.showPublishButton ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 48),
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 64,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 32, right: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(ColorConstants.getPeachDark()),
                      boxShadow: ElevationToShadow[4],
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Publish Changes',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ) : SizedBox()
            ],
          ),
        ),
      );
}

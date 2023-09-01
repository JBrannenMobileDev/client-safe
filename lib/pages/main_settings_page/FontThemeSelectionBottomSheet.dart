import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import 'ColorThemeWidget.dart';


class FontThemeSelectionBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FontThemeSelectionBottomSheetPageState();
  }
}

class _FontThemeSelectionBottomSheetPageState extends State<FontThemeSelectionBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, MainSettingsPageState>(
    converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
    builder: (BuildContext context, MainSettingsPageState pageState) =>
         Container(
           height: 650,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 16.0, right: 16.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(top: 24, bottom: 24.0),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Select a Font Theme',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.primary_black),
                     ),
                   ),
                   SingleChildScrollView(
                     child: Container(
                       height: 575,
                       child: ListView.builder(
                           padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 300.0),
                           itemCount: pageState.savedFontThemes.length,
                           controller: _controller,
                           physics: AlwaysScrollableScrollPhysics(),
                           key: _listKey,
                           shrinkWrap: true,
                           reverse: false,
                           itemBuilder: _buildItem
                       ),
                     ),
                   ),
                 ],
               ),
         ),
    );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, MainSettingsPageState>(
        converter: (store) => MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) =>
            GestureDetector(
              onTap: () {
                pageState.onFontThemeSelected(pageState.savedFontThemes.elementAt(index));
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  TextDandyLight(
                    textAlign: TextAlign.center,
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: pageState.savedFontThemes.elementAt(index).themeName,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(ColorConstants.getPrimaryGreyMedium()),
                          width: 1,
                        )
                    ),
                    margin: EdgeInsets.only(top: 12, bottom: 48, left: 16, right: 16),
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Column(
                      children: [
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
                                    text: pageState.savedFontThemes.elementAt(index).iconFont,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
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
                                    text: pageState.savedFontThemes.elementAt(index).titleFont,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
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
                                  text: 'Body font',
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
                                    text: pageState.savedFontThemes.elementAt(index).bodyFont,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
    );
  }
}
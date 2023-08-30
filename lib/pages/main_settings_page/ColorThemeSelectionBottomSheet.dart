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


class ColorThemeSelectionBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ColorThemeSelectionBottomSheetPageState();
  }
}

class _ColorThemeSelectionBottomSheetPageState extends State<ColorThemeSelectionBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, MainSettingsPageState>(
    converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
    builder: (BuildContext context, MainSettingsPageState pageState) =>
         Container(
           height: 550,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(top: 24, bottom: 24.0),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Select a Color Theme',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.primary_black),
                     ),
                   ),
                   SingleChildScrollView(
                     child: Container(
                       height: 372,
                       child: ListView.builder(
                           padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 300.0),
                           itemCount: pageState.savedColorThemes.length,
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
                pageState.onColorThemeSelected(pageState.savedColorThemes.elementAt(index));
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.only(top: 12, bottom: 12),
                color: Color(ColorConstants.getPrimaryWhite()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextDandyLight(
                      type: TextDandyLight.SMALL_TEXT,
                      text: pageState.savedColorThemes.elementAt(index).themeName,
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    Row(
                      children: [
                        ColorCircle(pageState.savedColorThemes.elementAt(index).iconColor),
                        ColorCircle(pageState.savedColorThemes.elementAt(index).iconTextColor),
                        ColorCircle(pageState.savedColorThemes.elementAt(index).buttonColor),
                        ColorCircle(pageState.savedColorThemes.elementAt(index).buttonTextColor),
                        ColorCircle(pageState.savedColorThemes.elementAt(index).bannerColor),
                        // pageState.savedColorThemes.elementAt(index).themeName != 'DandyLight Theme' ? GestureDetector(
                        //   onTap: () {
                        //     pageState.onColorThemeDeleted(pageState.savedColorThemes.elementAt(index));
                        //   },
                        //   child: Container(
                        //     margin: EdgeInsets.only(left: 8, right: 4),
                        //     height: 28,
                        //     child: Image.asset('assets/images/icons/trash.png', color: Color(ColorConstants.getPrimaryBlack()),),
                        //   ),
                        // ) : SizedBox(width: 40,),
                      ],
                    ),
                  ],
                ),
              ),
            )
    );
  }

  Widget ColorCircle(String color) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      height: 26,
      width: 26,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            width: 1,
            color: Color(ColorConstants.isWhiteString(color) ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryWhite()),
          ),
          color: ColorConstants.hexToColor(color)
      ),
    );
  }
}
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
           height: 550,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32),
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
                       height: 372,
                       child: ListView.builder(
                           padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 300.0),
                           itemCount: 5,
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
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.only(top: 12, bottom: 12),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'DandyLight Theme',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Icon:',
                                color: Color(ColorConstants.getPrimaryGreyMedium()),
                              ),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Sans Serif',
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Title:',
                                color: Color(ColorConstants.getPrimaryGreyMedium()),
                              ),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Sans Serif',
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Body:',
                                color: Color(ColorConstants.getPrimaryGreyMedium()),
                              ),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Sans Serif',
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_right,
                        color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      ),
                    ),
                  ],
                ),
              ),
            )
    );
  }
}
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';


class FontSelectionBottomSheet extends StatefulWidget {
  final String id;

  FontSelectionBottomSheet(this.id);

  @override
  State<StatefulWidget> createState() {
    return _FontSelectionBottomSheetPageState(id);
  }
}

class _FontSelectionBottomSheetPageState extends State<FontSelectionBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> allFonts = FontTheme.getAllFonts();
  final String id;

  _FontSelectionBottomSheetPageState(this.id);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, MainSettingsPageState>(
    converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
    builder: (BuildContext context, MainSettingsPageState pageState) =>
         Container(

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
                       text: 'Select a Font',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.primary_black),
                     ),
                   ),
                   SingleChildScrollView(
                     child: Container(
                       height: 500,
                       child: ListView.builder(
                           padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 300.0),
                           itemCount: FontTheme.getAllFonts().length,
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
                pageState.onFontSaved(allFonts.elementAt(index), id);
                Navigator.of(context).pop();
                if(id == FontTheme.ICON_FONT_ID) {
                  EventSender().sendEvent(eventName: EventNames.BRANDING_ICON_FONT_CHANGED);
                }
                if(id == FontTheme.MAIN_FONT_ID) {
                  EventSender().sendEvent(eventName: EventNames.BRANDING_MAIN_FONT_CHANGED);
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 12, bottom: 12),
                child: Container(
                  alignment: Alignment.center,
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    fontFamily: allFonts.elementAt(index),
                    text: allFonts.elementAt(index),
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
            )
    );
  }
}
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../widgets/TextDandyLight.dart';
import 'ShareWithClientPageState.dart';


class ChooseMessageBottomSheet extends StatefulWidget {
  final Function(String) setSelectedMessage;
  ChooseMessageBottomSheet(this.setSelectedMessage);


  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState(setSelectedMessage);
  }
}

class _BottomSheetPageState extends State<ChooseMessageBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Function(String) setSelectedMessage;

  _BottomSheetPageState(this.setSelectedMessage);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ShareWithClientPageState>(
    onDidChange: (previous, current) {

    },
    converter: (Store<AppState> store) => ShareWithClientPageState.fromStore(store),
    builder: (BuildContext context, ShareWithClientPageState pageState) =>
         Stack(
           alignment: Alignment.topRight,
           children: [
             Container(
               height: MediaQuery.of(context).size.height-62,
               decoration: BoxDecoration(
                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: const EdgeInsets.only(left: 32.0, right: 32.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Container(
                     margin: const EdgeInsets.only(top: 24, bottom: 0.0),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Select a client portal message',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                   SingleChildScrollView(
                     child: Container(
                       height: MediaQuery.of(context).size.height-116,
                       child: ListView.builder(
                           padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 200.0),
                           itemCount: pageState.jobs!.length,
                           controller: _controller,
                           physics: const AlwaysScrollableScrollPhysics(),
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
             GestureDetector(
               onTap: () {
                 Navigator.of(context).pop();
               },
               child: Container(
                 height: 54,
                 width: 54,
                 margin: const EdgeInsets.only(),
                 child: Icon(Icons.close, color: Color(ColorConstants.getPrimaryBlack(),)
               ),
               ),
             ),
           ],
         ),
    );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, ShareWithClientPageState>(
        converter: (store) => ShareWithClientPageState.fromStore(store),
        builder: (BuildContext context, ShareWithClientPageState pageState) =>
            GestureDetector(
              onTap: () {
                setSelectedMessage(pageState.jobs!.elementAt(index).proposal!.detailsMessage!);
                pageState.onMessageChanged!(pageState.jobs!.elementAt(index).proposal!.detailsMessage!);
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 32, bottom: 8),
                    alignment: Alignment.center,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: pageState.jobs!.elementAt(index).jobTitle,
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    height: 204,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                        color: Color(ColorConstants.getPrimaryBackgroundGrey()).withOpacity(0.25),
                        borderRadius: const BorderRadius.all(Radius.circular(32.0))),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: pageState.jobs!.elementAt(index).proposal!.detailsMessage!,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.fade,
                      maxLines: 9,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  )
                ],
              ),
            )
    );
  }
}
import 'package:dandylight/navigation/routes/RouteNames.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import 'MainSettingsPageState.dart';


class PreviewOptionsBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PreviewOptionsBottomSheetState();
  }
}

class _PreviewOptionsBottomSheetState extends State<PreviewOptionsBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> options = ['Client Portal', 'Contract PDF', 'Invoice PDF'];

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, MainSettingsPageState>(
      converter: (store) => MainSettingsPageState.fromStore(store),
      builder: (BuildContext context, MainSettingsPageState pageState) =>
          GestureDetector(
            onTap: () {
              _launchBrandingPreviewURL(pageState.profile.uid);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              height: 54.0,
              decoration: new BoxDecoration(
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()).withOpacity(0.25),
                  borderRadius: new BorderRadius.all(Radius.circular(32.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(right: 18.0, left: 16.0, top: 4),
                        height: 28.0,
                        width: 28.0,
                        child: Icon(Icons.visibility, color: Color(ColorConstants.getPrimaryGreyMedium()),),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: options.elementAt(index),
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ],
                  ),
                  Container(
                    height: 28,
                    margin: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.chevron_right, color: Color(ColorConstants.getPrimaryBackgroundGrey()),),
                  ),
                ],
              )
            ),
          )
    );
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, LibraryPoseGroupPageState>(
    converter: (Store<AppState> store) => LibraryPoseGroupPageState.fromStore(store),
    builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
         Container(
           height: 324,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: EdgeInsets.only(left: 16.0, right: 16.0),
             child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(top: 24, bottom: 16),
                       child: TextDandyLight(
                         type: TextDandyLight.MEDIUM_TEXT,
                         text: 'What do you want to preview?',
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.primary_black),
                       ),
                     ),
                     ListView.builder(
                         padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                         itemCount: 3,
                         controller: _controller,
                         physics: AlwaysScrollableScrollPhysics(),
                         key: _listKey,
                         shrinkWrap: true,
                         reverse: false,
                         itemBuilder: _buildItem
                     ),
                   ],
           ),
         ),
    );

  void _launchBrandingPreviewURL(String uid) async => await canLaunchUrl(Uri.parse('https://clientsafe-21962.web.app/' + RouteNames.BRANDING_PREVIEW + '/' + uid)) ? await launchUrl(Uri.parse('https://clientsafe-21962.web.app/' + RouteNames.BRANDING_PREVIEW + '/' + uid)) : throw 'Could not launch';
}
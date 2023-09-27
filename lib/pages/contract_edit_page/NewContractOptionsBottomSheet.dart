import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/navigation/routes/RouteNames.dart';
import 'package:dandylight/pages/contract_edit_page/ContractEditPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ContractTemplatesUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/NavigationUtil.dart';


class NewContractOptionsBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _NewContractOptionsBottomSheetState();
  }
}

class _NewContractOptionsBottomSheetState extends State<NewContractOptionsBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> options = ['Blank Contract', 'General (template)', 'Wedding (template)', 'Portrait (template)'];

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, ContractEditPageState>(
      converter: (store) => ContractEditPageState.fromStore(store),
      builder: (BuildContext context, ContractEditPageState pageState) =>
          GestureDetector(
            onTap: () {
              switch(options.elementAt(index)) {
                case 'Blank Contract':
                  Navigator.of(context).pop();
                  NavigationUtil.onContractSelected(context, null, "Blank Contract", true);
                  break;
                case 'General (template)':
                  Navigator.of(context).pop();
                  Contract generalContract = ContractTemplatesUtil.getGeneralContract();
                  NavigationUtil.onContractSelected(context, generalContract, generalContract.contractName, true);
                  break;
                case 'Wedding (template)':
                  Navigator.of(context).pop();
                  Contract weddingContract = ContractTemplatesUtil.getWeddingContract();
                  NavigationUtil.onContractSelected(context, weddingContract, "Wedding Contract", true);
                  break;
                case 'Portrait (template)':
                  Navigator.of(context).pop();
                  Contract portraitContract = ContractTemplatesUtil.getPortraitContract();
                  NavigationUtil.onContractSelected(context, portraitContract, "Portrait Contract", true);
                  break;
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
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
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 8.0, left: 24.0),
                        height: 28.0,
                        width: 28.0,
                        child: Image.asset('assets/images/collection_icons/contract_icon_white.png', color: Color(ColorConstants.getPrimaryBlack())),
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
           height: 416,
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
                         text: 'How would you like to start?',
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.primary_black),
                       ),
                     ),
                     ListView.builder(
                         padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                         itemCount: 4,
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

  void _launchBrandingPreviewURL(String uid) async => await canLaunchUrl(Uri.parse('https://clientsafe-21962.web.app/' + RouteNames.BRANDING_PREVIEW + '/' + uid)) ? await launchUrl(Uri.parse('https://clientsafe-21962.web.app/' + RouteNames.BRANDING_PREVIEW + '/' + uid), mode: LaunchMode.platformDefault) : throw 'Could not launch';
}
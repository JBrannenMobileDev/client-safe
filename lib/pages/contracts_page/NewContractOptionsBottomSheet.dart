import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/NavigationUtil.dart';
import 'ContractsPageState.dart';


class NewContractOptionsBottomSheet extends StatefulWidget {
  final String? jobDocumentId;

  NewContractOptionsBottomSheet({this.jobDocumentId = null});

  @override
  State<StatefulWidget> createState() {
    return _NewContractOptionsBottomSheetState(jobDocumentId);
  }
}

class _NewContractOptionsBottomSheetState extends State<NewContractOptionsBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> options = ['Blank Contract', 'General (template)', 'Wedding (template)', 'Portrait (template)'];
  final String? jobDocumentId;

  _NewContractOptionsBottomSheetState(this.jobDocumentId);

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, ContractsPageState>(
      converter: (store) => ContractsPageState.fromStore(store),
      builder: (BuildContext context, ContractsPageState pageState) =>
          GestureDetector(
            onTap: () {
              switch(options.elementAt(index)) {
                case 'Blank Contract':
                  Navigator.of(context).pop();
                  Contract generalContract = pageState.contractTemplates!.firstWhere((template) => template.contractName == options.elementAt(index));
                  NavigationUtil.onContractSelected(context, generalContract, "Blank Contract", true, jobDocumentId, null);
                  break;
                case 'General (template)':
                  Navigator.of(context).pop();
                  Contract generalContract = pageState.contractTemplates!.firstWhere((template) => template.contractName == options.elementAt(index));
                  NavigationUtil.onContractSelected(context, generalContract, "General Contract", true, jobDocumentId, null);
                  break;
                case 'Wedding (template)':
                  Navigator.of(context).pop();
                  Contract weddingContract = pageState.contractTemplates!.firstWhere((template) => template.contractName == options.elementAt(index));
                  NavigationUtil.onContractSelected(context, weddingContract, "Wedding Contract", true, jobDocumentId, null);
                  break;
                case 'Portrait (template)':
                  Navigator.of(context).pop();
                  Contract portraitContract = pageState.contractTemplates!.firstWhere((template) => template.contractName == options.elementAt(index));
                  NavigationUtil.onContractSelected(context, portraitContract, "Portrait Contract", true, jobDocumentId, null);
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
                        color: Color(ColorConstants.getPrimaryBlack()),
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
                         color: Color(ColorConstants.getPrimaryBlack()),
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

}
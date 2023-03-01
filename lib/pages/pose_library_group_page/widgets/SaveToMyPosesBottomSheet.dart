import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/MyPoseGroupsListItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/UserOptionsUtil.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../new_contact_pages/NewContactPageState.dart';
import '../LibraryPoseGroupActions.dart';


class SaveToMyPosesBottomSheet extends StatefulWidget {
  final int libraryPoseIndex;

  SaveToMyPosesBottomSheet(this.libraryPoseIndex);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState(libraryPoseIndex);
  }
}

class _BottomSheetPageState extends State<SaveToMyPosesBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final int libraryPoseIndex;

  _BottomSheetPageState(this.libraryPoseIndex);

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      converter: (store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          GestureDetector(
            onTap: () {
              pageState.onImageSaveSelected(pageState.poseImages.elementAt(libraryPoseIndex), pageState.myPoseGroups.elementAt(index));
              showSuccessAnimation();
              EventSender().sendEvent(eventName: EventNames.BT_SAVE_LIBRARY_POSE, properties: {EventNames.SAVE_LIBRARY_POSE_PARAM_GROUP_NAME : pageState.poseGroup.groupName});
            },
            child: MyPoseGroupsListItemWidget(index),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, LibraryPoseGroupPageState>(
    converter: (Store<AppState> store) => LibraryPoseGroupPageState.fromStore(store),
    builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
         Container(
               height: 350,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 16.0, right: 16.0),
               child: Stack(
                 children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       Container(
                         margin: EdgeInsets.only(top: 24),
                         child: TextDandyLight(
                           type: TextDandyLight.LARGE_TEXT,
                           text: 'Save to My Poses',
                           textAlign: TextAlign.center,
                           color: Color(ColorConstants.primary_black),
                         ),
                       ),
                       pageState.myPoseGroups.length > 0 ? SingleChildScrollView(
                         child: Container(
                           height: 302,
                           child: GridView.builder(
                               padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 300.0),
                               gridDelegate:
                               const SliverGridDelegateWithMaxCrossAxisExtent(
                                   maxCrossAxisExtent: 150,
                                   childAspectRatio: 3 / 3,
                                   crossAxisSpacing: 0,
                                   mainAxisSpacing: 0
                               ),
                               itemCount: pageState.myPoseGroups.length,
                               controller: _controller,
                               physics: AlwaysScrollableScrollPhysics(),
                               key: _listKey,
                               shrinkWrap: true,
                               reverse: false,
                               itemBuilder: _buildItem
                           ),
                         ),
                       ) : Container(
                         margin: EdgeInsets.only(top: 32),
                         child: TextDandyLight(
                           type: TextDandyLight.MEDIUM_TEXT,
                           textAlign: TextAlign.center,
                           text: 'You don\'t have any Collections yet! \nSelect the + icon to create your first Pose Collection.',
                           color: Color(ColorConstants.getPeachDark()),
                         ),
                       ),
                     ],
                   ),
                   GestureDetector(
                     onTap: () {
                       UserOptionsUtil.showNewPoseGroupDialog(context);
                     },
                     child: Align(
                       alignment: Alignment.topRight,
                       child: Container(
                           height: 24,
                           width: 24,
                           margin: EdgeInsets.only(right: 8.0, top: 22.0),
                           child: Image.asset(
                             'assets/images/icons/plus.png',
                             color: Color(ColorConstants.getPeachDark()),
                             height: 24,
                             width: 24,
                           )
                       ),
                     ),
                   ),
                 ],
               ),
             ),
    );

  void showSuccessAnimation(){
    DandyToastUtil.showToastWithGravity('Added!', Color(ColorConstants.getPeachDark()), ToastGravity.CENTER);
    Navigator.of(context).pop();
  }
}
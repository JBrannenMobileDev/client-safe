import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/MyPoseGroupsListItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/DandyToastUtil.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../new_contact_pages/NewContactPageState.dart';


class SaveToJobBottomSheet extends StatefulWidget {
  final int? libraryPoseIndex;

  SaveToJobBottomSheet(this.libraryPoseIndex);

  @override
  State<StatefulWidget> createState() {
    return _SaveToJobBottomSheetState(libraryPoseIndex);
  }
}

class _SaveToJobBottomSheetState extends State<SaveToJobBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final int? libraryPoseIndex;

  _SaveToJobBottomSheetState(this.libraryPoseIndex);

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, PoseGroupPageState>(
      converter: (store) => PoseGroupPageState.fromStore(store),
      builder: (BuildContext context, PoseGroupPageState pageState) =>
          GestureDetector(
            onTap: () {
              pageState.onImageAddedToJobSelected!(pageState.poseImages!.elementAt(libraryPoseIndex!), pageState.activeJobs!.elementAt(index));
              showSuccessAnimation();
              EventSender().sendEvent(eventName: EventNames.BT_SAVE_MY_POSE_TO_JOB);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              height: 54.0,
              decoration: new BoxDecoration(
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()).withOpacity(0.25),
                  borderRadius: new BorderRadius.all(Radius.circular(32.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(right: 18.0, left: 16.0),
                        height: 28.0,
                        width: 28.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/icons/briefcase_icon_peach_dark.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: pageState.activeJobs!.elementAt(index).jobTitle,
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ],
                  ),
                  Container(
                    height: 24,
                    margin: EdgeInsets.only(right: 16.0),
                    child: Image.asset(
                      'assets/images/icons/plus.png',
                      color: Color(ColorConstants.getPeachDark()),
                    ),
                  ),
                ],
              )
            ),
          )
    );
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, PoseGroupPageState>(
    converter: (Store<AppState> store) => PoseGroupPageState.fromStore(store),
    builder: (BuildContext context, PoseGroupPageState pageState) =>
         Container(
           height: pageState.activeJobs!.length <= 4 ? 400 : pageState.activeJobs!.length <= 5 ? 500 : 600,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: EdgeInsets.only(left: 16.0, right: 16.0),
             child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(top: 24),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: 'Save to Job',
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.getPrimaryBlack()),
                       ),
                     ),
                     SingleChildScrollView(
                       child: Container(
                       height: pageState.activeJobs!.length <= 4 ? 400 - 54 : pageState.activeJobs!.length <= 5 ? 500 - 54 : 600 - 54,
                       child: ListView.builder(
                           padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 300.0),
                           itemCount: pageState.activeJobs!.length,
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

  void showSuccessAnimation(){
    DandyToastUtil.showToastWithGravity('Added!', Color(ColorConstants.getPeachDark()), ToastGravity.CENTER);
    Navigator.of(context).pop();
  }
}
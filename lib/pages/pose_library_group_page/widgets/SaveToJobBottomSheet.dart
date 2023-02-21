import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/MyPoseGroupsListItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../new_contact_pages/NewContactPageState.dart';


class SaveToJobBottomSheet extends StatefulWidget {
  final int libraryPoseIndex;

  SaveToJobBottomSheet(this.libraryPoseIndex);

  @override
  State<StatefulWidget> createState() {
    return _SaveToJobBottomSheetState(libraryPoseIndex);
  }
}

class _SaveToJobBottomSheetState extends State<SaveToJobBottomSheet> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final int libraryPoseIndex;

  _SaveToJobBottomSheetState(this.libraryPoseIndex);

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      converter: (store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          GestureDetector(
            onTap: () {
              pageState.onImageAddedToJobSelected(pageState.poseImages.elementAt(libraryPoseIndex).pose, pageState.activeJobs.elementAt(index));
              showSuccessAnimation();
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
                        text: pageState.activeJobs.elementAt(index).jobTitle,
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_black),
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
  Widget build(BuildContext context) => StoreConnector<AppState, LibraryPoseGroupPageState>(
    converter: (Store<AppState> store) => LibraryPoseGroupPageState.fromStore(store),
    builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
         Container(
           height: pageState.activeJobs.length <= 4 ? 400 : pageState.activeJobs.length <= 5 ? 500 : 600,
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
                         color: Color(ColorConstants.primary_black),
                       ),
                     ),
                     SingleChildScrollView(
                       child: Container(
                       height: 302,
                       child: ListView.builder(
                           padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 300.0),
                           itemCount: pageState.activeJobs.length,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
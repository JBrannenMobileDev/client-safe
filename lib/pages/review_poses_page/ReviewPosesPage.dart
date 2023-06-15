import 'dart:io';

import 'package:dandylight/pages/pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import 'package:dandylight/pages/review_poses_page/DecisionPager.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../models/Profile.dart';
import '../pose_group_page/GroupImage.dart';
import '../upload_pose_page/UploadPosePage.dart';
import 'ReviewPosesActions.dart';
import 'ReviewPosesPageState.dart';


class ReviewPosesPage extends StatefulWidget {
  static const String ENGAGEMENT = "Engagement";
  static const String FAMILIES = "Families";
  static const String COUPLES = "Couples";
  static const String PORTRAITS = "Portraits";
  static const String MATERNITY = "Maternity";
  static const String WEDDINGS = "Weddings";
  static const String NEWBORN = "Newborn";
  static const String PROPOSALS = "Proposals";
  static const String PETS = "Pets";

  @override
  State<StatefulWidget> createState() {
    return _ReviewPosesPageState();
  }
}

class _ReviewPosesPageState extends State<ReviewPosesPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ReviewPosesPageState>(
    onInit: (store) {
      store.dispatch(ClearReviewPosesStateAction(store.state.reviewPosesPageState));
      store.dispatch(LoadPosesToReviewAction(store.state.reviewPosesPageState));
    },
    converter: (Store<AppState> store) => ReviewPosesPageState.fromStore(store),
    builder: (BuildContext context, ReviewPosesPageState pageState) =>
         Scaffold(
           appBar: AppBar(
             iconTheme: IconThemeData(
               color: Color(ColorConstants.getPrimaryBlack())
             ),
             title: TextDandyLight(
               type: TextDandyLight.LARGE_TEXT,
               text: 'Review Submissions',
               textAlign: TextAlign.center,
               color: Color(ColorConstants.primary_black),
             ),
             backgroundColor: Color(ColorConstants.getPrimaryWhite()),
             elevation: 0,
           ),
           backgroundColor: Color(ColorConstants.getPrimaryWhite()),
           body: GridView.builder(
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
             itemBuilder: (_, index) => _buildItem(context, index, pageState),
             itemCount: pageState.groupImages.length,
           ),
         ),
    );

  Widget _buildItem(BuildContext context, int index, ReviewPosesPageState pageState) {
    GroupImage groupImage = pageState.groupImages.elementAt(index);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => DecisionPager(
              pageState.groupImages,
              index,
          )),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left:0.5, right: 0.5, top: 1),
        child: ClipRRect(
          child: Image(
            fit: BoxFit.cover,
            image: groupImage.file != null ? FileImage(File(groupImage.file.path))
                : AssetImage("assets/images/backgrounds/image_background.png"),
          ),
        ),
      ),
    );
  }
}
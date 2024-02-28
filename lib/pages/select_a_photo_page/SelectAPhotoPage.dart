import 'dart:io';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import 'SelectAPhotoActions.dart';
import 'SelectAPhotoPageState.dart';


class SelectAPhotoPage extends StatefulWidget {
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
    return _SelectAPhotoPageState();
  }
}

class _SelectAPhotoPageState extends State<SelectAPhotoPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, SelectAPhotoPageState>(
    onInit: (store) {
      store.dispatch(ClearSelectAPoseStateAction(store.state.selectAPhotoPageState));
      store.dispatch(LoadUploadedPhotosAction(store.state.selectAPhotoPageState));
    },
    converter: (Store<AppState> store) => SelectAPhotoPageState.fromStore(store),
    builder: (BuildContext context, SelectAPhotoPageState pageState) =>
         Scaffold(
           appBar: AppBar(
             iconTheme: IconThemeData(
               color: Color(ColorConstants.getPrimaryBlack())
             ),
             title: TextDandyLight(
               type: TextDandyLight.LARGE_TEXT,
               text: 'Select a Photo',
               textAlign: TextAlign.center,
               color: Color(ColorConstants.getPrimaryBlack()),
             ),
             actions: [
               GestureDetector(
                 onTap: () {

                 },
                 child: Container(
                   alignment: Alignment.center,
                   padding: EdgeInsets.all(16),
                   height: 54,
                   child: Image.asset(
                     'assets/images/icons/file_upload.png',
                     color: Color(ColorConstants.getPrimaryBlack()),
                     width: 26,
                   ),
                 ),
               )
             ],
             backgroundColor: Color(ColorConstants.getPrimaryWhite()),
             elevation: 0,
           ),
           backgroundColor: Color(ColorConstants.getPrimaryWhite()),
           body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    height: 32,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'My uploads',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (_, index) => _buildItem(context, index, pageState),
                    itemCount: pageState.urls.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                  ),
                ],
              ),
           ),
         ),
    );

  Widget _buildItem(BuildContext context, int index, SelectAPhotoPageState pageState) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.only(left:0.5, right: 0.5, top: 1),
        child: DandyLightNetworkImage(
          pageState.urls.elementAt(index),
          resizeWidth: 350,
          borderRadius: 0,
        )
      ),
    );
  }
}
import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';


class JobPoseListWidget extends StatelessWidget {
  final int index;

  JobPoseListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: pageState.poseImages.isNotEmpty ? FileImage(File(pageState.poseImages.elementAt(index).file.path))
                        : AssetImage("assets/images/backgrounds/image_background.png"),
                  ),
                ),
              ),
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                        begin: FractionalOffset.center,
                        end: FractionalOffset.topCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.05),
                        ],
                        stops: [
                          0.0,
                          1.0
                        ])),
              ),
              GestureDetector(
                onTap: () {
                  pageState.onDeletePoseSelected(index);
                },
                child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 24,
                        width: 24,
                        margin: EdgeInsets.only(right: 8.0, top: 8.0),
                        child: Image.asset(
                          'assets/images/icons/trash.png',
                          color: Color(ColorConstants.getPrimaryWhite()),
                          height: 24,
                          width: 24,
                        )
                    ),
                  ),
              ),
            ],
          ),
    );
  }
}

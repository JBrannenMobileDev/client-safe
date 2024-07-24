import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../widgets/DandyLightNetworkImage.dart';
import '../../../widgets/TextDandyLight.dart';


class AddPoseToJobTip extends StatefulWidget {

  @override
  _AddPoseToJobTipState createState() {
    return _AddPoseToJobTipState();
  }
}

class _AddPoseToJobTipState extends State<AddPoseToJobTip> {

  final int pageCount = 2;
  final controller = PageController(
    initialPage: 0,
  );
  String? clientDocumentId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    width: 296.0,
                    height: 442,
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    decoration: const BoxDecoration(
                        color: Color(ColorConstants.white),
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 16),
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: 'Tip',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 32),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Select the + icon on a pose to add it to a job.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 264,
                          width: 196,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              DandyLightNetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2Fb593bcc0-8d21-1f86-8f14-b52dc30f2b34.jpg?alt=media&token=8fc6a760-251c-419e-9a08-5f41e4f9693d'
                              ),
                              Container(
                                height: 150.0,
                                width: 196,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    borderRadius: new BorderRadius.circular(8.0),
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.center,
                                        end: FractionalOffset.topCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.15),
                                        ],
                                        stops: [
                                          0.0,
                                          1.0
                                        ])),
                              ),
                              GestureDetector(
                                onTap: () {
                                },
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      height: 24,
                                      width: 24,
                                      margin: EdgeInsets.only(left: 8.0, top: 8.0),
                                      child: Image.asset(
                                        'assets/images/icons/plus.png',
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                        height: 24,
                                        width: 24,
                                      )
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {

                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                      height: 24,
                                      width: 24,
                                      margin: EdgeInsets.only(right: 8.0, top: 8.0),
                                      child: Image.asset(
                                        'assets/images/icons/ribbon.png',
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                        height: 24,
                                        width: 24,
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, top: 16),
                  alignment: Alignment.topLeft,
                  width: 296.0,
                  height: 442,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close, color: Color(ColorConstants.getPrimaryBlack())),
                    )
                ),
              ],
            ),
      ),
    );
  }
}

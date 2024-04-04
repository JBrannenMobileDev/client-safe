import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/new_contact_pages/LeadSourceSelection.dart';
import 'package:dandylight/pages/new_contact_pages/NameAndGender.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/pages/new_contact_pages/PhoneEmailInstagram.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/InputValidatorUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/TextDandyLight.dart';

class NewContactPage extends StatefulWidget {
  final bool? comingFromNewJob;
  NewContactPage({this.comingFromNewJob});

  @override
  _NewContactPageState createState() {
    return _NewContactPageState(comingFromNewJob);
  }
}

class _NewContactPageState extends State<NewContactPage> {
  _NewContactPageState(this.comingFromNewJob);

  final bool? comingFromNewJob;
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
      onInit: (store) async{
        if(comingFromNewJob!) {
          store.dispatch(SetIsComingFromNewJobAction(store.state.newContactPageState));
        }
        store.state.newContactPageState!.shouldClear! ? store.dispatch(ClearStateAction(store.state.newContactPageState)) : null;
      },
      onDidChange: (prev, pageState) {
        if(pageState.client != null) {
          if (pageState.client!.documentId != null) {
            clientDocumentId = pageState.client!.documentId;
          }
        }
      },
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          WillPopScope(
          onWillPop: () async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => new CupertinoAlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('All unsaved information entered will be lost.'),
                actions: <Widget>[
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes'),
                  ),
                ],
              ),
            );
            return shouldPop!;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 375.0,
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                decoration: new BoxDecoration(
                    color: Color(ColorConstants.white),
                    borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child:
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: pageState.shouldClear! ? "New Contact" : "Edit Contact",
                            textAlign: TextAlign.start,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 300.0),
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Delete',
                              color: Color(ColorConstants.getPeachDark()),
                              onPressed: () {
                                pageState.onCancelPressed!();
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ),
                          !pageState.shouldClear! ? Container(
                            margin: EdgeInsets.only(left: 300.0),
                            child: IconButton(
                              icon: const Icon(Icons.save),
                              tooltip: 'Save',
                              color: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                showSuccessAnimation();
                                pageState.onSavePressed!();
                              },
                            ),
                          ) : SizedBox(),
                        ],
                      ),
                    ),
                    Container(
                      height: pageState.pageViewIndex == 0 && pageState.deviceContacts!.length > 0 ? 350.0 : _getWidgetHeight(pageState.pageViewIndex!),
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        pageSnapping: true,
                        children: <Widget>[
                          NameAndGender(),
                          PhoneEmailInstagram(),
                          LeadSourceSelection(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 26.0, right: 26.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            style: Styles.getButtonStyle(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              textColor: Color(ColorConstants.getPrimaryBlack()),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            //disabled button color needs to be white
                            //disabled textColor needs to be Color(ColorConstants.primary_bg_grey),
                            onPressed: () {
                              onBackPressed(pageState);
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: pageState.pageViewIndex == 0 ? "Cancel" : "Back",
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          TextButton(
                            style: Styles.getButtonStyle(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              textColor: Color(ColorConstants.getPrimaryBlack()),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            //disabled button color needs to be white
                            //disabled textColor needs to be Color(ColorConstants.primary_bg_grey),
                            onPressed: () {
                              onNextPressed(pageState);
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: pageState.pageViewIndex == pageCount
                                  ? "Save"
                                  : "Next",
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }

  double _getWidgetHeight(int index) {
    switch(index) {
      case 0:
        return 256.0;
      case 1:
        return 256.0;
      case 2:
        return 312.0;
    }
    return 256.0;
  }

  void onNextPressed(NewContactPageState pageState) async {
    bool canProgress = false;
    if (pageState.pageViewIndex != pageCount) {
      switch (pageState.pageViewIndex) {
        case 0:
          if (pageState.newContactFirstName!.isNotEmpty) {
            canProgress = true;
          } else {
            pageState.onErrorStateChanged!(NewContactPageState.ERROR_FIRST_NAME_MISSING);
            HapticFeedback.heavyImpact();
          }
          break;
        case 1:
            if (!InputValidatorUtil.isEmailValid(pageState.newContactEmail!)) {
              pageState.onErrorStateChanged!(
                  NewContactPageState.ERROR_EMAIL_NAME_INVALID);
              HapticFeedback.heavyImpact();
              break;
            }

            if (!InputValidatorUtil.isPhoneNumberValid(pageState.newContactPhone!)) {
              pageState.onErrorStateChanged!(NewContactPageState.ERROR_PHONE_INVALID);
              HapticFeedback.heavyImpact();
              break;
            }

            if (!InputValidatorUtil.isInstagramUrlValid(pageState.newContactInstagramUrl!)) {
              pageState.onErrorStateChanged!(NewContactPageState.ERROR_INSTAGRAM_URL_INVALID);
              HapticFeedback.heavyImpact();
              break;
            }
            canProgress = true;
          break;
        default:
          canProgress = true;
          break;
      }

      if (canProgress) {
        pageState.onNextPressed!();
        controller.animateToPage(pageState.pageViewIndex! + 1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        FocusScope.of(context).unfocus();
      }
    }
    if (pageState.pageViewIndex == pageCount) {
      await UserPermissionsUtil.showPermissionRequest(permission: Permission.contacts, context: context);
      showSuccessAnimation();
      pageState.onSavePressed!();
    }
  }

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

  void onFlareCompleted(String unused) async{
    Navigator.of(context).pop();
    List<Job>? jobs = await JobDao.getAllJobs();
    List<Job> thisClientsJobs = jobs!.where((job) => job.clientDocumentId == clientDocumentId).toList();
    if(thisClientsJobs.length == 0 && !comingFromNewJob!){
      Navigator.of(context).pop();
      UserOptionsUtil.showJobPromptDialog(context);
    }else {
      Navigator.of(context).pop();
    }
  }

  void onBackPressed(NewContactPageState pageState) {
    if (pageState.pageViewIndex == 0) {
      pageState.onCancelPressed!();
      Navigator.of(context).pop();
    } else {
      pageState.onBackPressed!();
      controller.animateToPage(pageState.pageViewIndex! - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }
}

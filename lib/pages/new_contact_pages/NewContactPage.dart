import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/Children.dart';
import 'package:client_safe/pages/new_contact_pages/ImportantDates.dart';
import 'package:client_safe/pages/new_contact_pages/LeadSourceSelection.dart';
import 'package:client_safe/pages/new_contact_pages/MarriedSpouse.dart';
import 'package:client_safe/pages/new_contact_pages/NameAndGender.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_contact_pages/Notes.dart';
import 'package:client_safe/pages/new_contact_pages/PhoneEmailInstagram.dart';
import 'package:client_safe/pages/new_contact_pages/ProfileIcons.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/InputValidatorUtil.dart';
import 'package:client_safe/utils/UserPermissionsUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';

class NewContactPage extends StatefulWidget {
  @override
  _NewContactPageState createState() {
    return _NewContactPageState();
  }
}

class _NewContactPageState extends State<NewContactPage> {
  final int pageCount = 7;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new CupertinoAlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('All unsaved information entered will be lost.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      currentPageIndex = controller.page.toInt();
    });
    return StoreConnector<AppState, NewContactPageState>(
      onInit: (store) async{
        store.state.newContactPageState.shouldClear ? store.dispatch(ClearStateAction(store.state.newContactPageState)) : null;
        PermissionStatus readContactsStatus = await UserPermissionsUtil.getPermissionStatus(PermissionGroup.contacts);
        if(readContactsStatus == PermissionStatus.denied || readContactsStatus == PermissionStatus.disabled
            || readContactsStatus == PermissionStatus.unknown){
          _checkPermissions(context, store.state.newContactPageState);
        }
      },
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 375.0,
                padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
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
                          Text(
                            pageState.shouldClear ? "New Client" : "Edit Client",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                          !pageState.shouldClear ? Container(
                            margin: EdgeInsets.only(right: 300.0),
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Delete',
                              color: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ) : SizedBox(),
                          !pageState.shouldClear ? Container(
                            margin: EdgeInsets.only(left: 300.0),
                            child: IconButton(
                              icon: const Icon(Icons.save),
                              tooltip: 'Save',
                              color: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                showSuccessAnimation();
                                pageState.onSavePressed();
                              },
                            ),
                          ) : SizedBox(),
                        ],
                      ),
                    ),
                    Container(
                      height: currentPageIndex == 0 && pageState.deviceContacts.length > 0 ? 370.0 : 236.0,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        pageSnapping: true,
                        children: <Widget>[
                          NameAndGender(),
                          PhoneEmailInstagram(),
                          MarriedSpouse(),
                          Children(),
                          ImportantDates(),
                          Notes(),
                          ProfileIcons(),
                          LeadSourceSelection(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 26.0, right: 26.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            color: Colors.white,
                            textColor: Color(ColorConstants.primary_black),
                            disabledColor: Colors.white,
                            disabledTextColor:
                                Color(ColorConstants.primary_bg_grey),
                            padding: EdgeInsets.all(8.0),
                            splashColor: Color(ColorConstants.getPrimaryColor()),
                            onPressed: () {
                              onBackPressed(pageState);
                            },
                            child: Text(
                              pageState.pageViewIndex == 0 ? "Cancel" : "Back",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                          FlatButton(
                            color: Colors.white,
                            textColor: Color(ColorConstants.primary_black),
                            disabledColor: Colors.white,
                            disabledTextColor:
                                Color(ColorConstants.primary_bg_grey),
                            padding: EdgeInsets.all(8.0),
                            splashColor: Color(ColorConstants.getPrimaryColor()),
                            onPressed: () {
                              onNextPressed(pageState);
                            },
                            child: Text(
                              pageState.pageViewIndex == pageCount
                                  ? "Save"
                                  : "Next",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
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

  Future<void> _checkPermissions(BuildContext context, NewContactPageState pageState){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Request Contacts Permission'),
          content: new Text('These permissions will be used to save clients you add to your device contacts app.'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () async {
                await UserPermissionsUtil.requestPermission(PermissionGroup.contacts);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Request Contacts Permission'),
          content: new Text('These permissions will be used to save clients you add to your device contacts app.'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () async{
                await UserPermissionsUtil.requestPermission(PermissionGroup.contacts);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void onNextPressed(NewContactPageState pageState) {
    bool canProgress = false;
    if (pageState.pageViewIndex != pageCount) {
      switch (pageState.pageViewIndex) {
        case 0:
          if (!pageState.newContactFirstName.contains("Client")) {
            canProgress = true;
          } else {
            pageState.onErrorStateChanged(
                NewContactPageState.ERROR_FIRST_NAME_MISSING);
            HapticFeedback.heavyImpact();
          }
          break;
        case 1:
          if ((pageState.newContactPhone.isNotEmpty ||
                  pageState.newContactEmail.isNotEmpty ||
                  pageState.newContactInstagramUrl.isNotEmpty) &&
              (InputValidatorUtil.isEmailValid(pageState.newContactEmail) &&
                  InputValidatorUtil.isPhoneNumberValid(
                      pageState.newContactPhone) &&
                  InputValidatorUtil.isInstagramUrlValid(
                      pageState.newContactInstagramUrl))) {
            canProgress = true;
          } else {
            if (pageState.newContactPhone.isEmpty &&
                pageState.newContactEmail.isEmpty &&
                pageState.newContactInstagramUrl.isEmpty) {
              pageState.onErrorStateChanged(
                  NewContactPageState.ERROR_MISSING_CONTACT_INFO);
              HapticFeedback.heavyImpact();
            }

            if (!InputValidatorUtil.isEmailValid(pageState.newContactEmail)) {
              pageState.onErrorStateChanged(
                  NewContactPageState.ERROR_EMAIL_NAME_INVALID);
              HapticFeedback.heavyImpact();
            }

            if (!InputValidatorUtil.isPhoneNumberValid(
                pageState.newContactPhone)) {
              pageState
                  .onErrorStateChanged(NewContactPageState.ERROR_PHONE_INVALID);
              HapticFeedback.heavyImpact();
            }

            if (!InputValidatorUtil.isInstagramUrlValid(
                pageState.newContactInstagramUrl)) {
              pageState.onErrorStateChanged(
                  NewContactPageState.ERROR_INSTAGRAM_URL_INVALID);
              HapticFeedback.heavyImpact();
            }
          }
          break;
        default:
          canProgress = true;
          break;
      }

      if (canProgress) {
        pageState.onNextPressed();
        controller.animateToPage(currentPageIndex + 1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
      }
    }
    if (pageState.pageViewIndex == pageCount) {
      showSuccessAnimation();
      pageState.onSavePressed();
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

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  void onBackPressed(NewContactPageState pageState) {
    if (pageState.pageViewIndex == 0) {
      pageState.onCancelPressed();
      Navigator.of(context).pop();
    } else {
      pageState.onBackPressed();
      controller.animateToPage(currentPageIndex - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }
}

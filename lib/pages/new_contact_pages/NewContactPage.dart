import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/Children.dart';
import 'package:client_safe/pages/new_contact_pages/ImportantDates.dart';
import 'package:client_safe/pages/new_contact_pages/MarriedSpouse.dart';
import 'package:client_safe/pages/new_contact_pages/NameAndGender.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_contact_pages/Notes.dart';
import 'package:client_safe/pages/new_contact_pages/PhoneEmailInstagram.dart';
import 'package:client_safe/pages/new_contact_pages/ProfileIcons.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewContactPage extends StatefulWidget {
  @override
  _NewContactPageState createState() {
    return _NewContactPageState();
  }
}

class _NewContactPageState extends State<NewContactPage> with AutomaticKeepAliveClientMixin{
  final controller = PageController(
    initialPage: 0,
  );

  final double pageWidth = 400.0;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    controller.addListener((){
      currentPageIndex = controller.page.toInt();
    });
    return StoreConnector<AppState, NewContactPageState>(
        converter: (store) => NewContactPageState.fromStore(store),
        builder: (BuildContext context, NewContactPageState pageState) =>
            Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: pageWidth,
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
                    child: Text(
                      "New Contact",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w800,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  Container(
                    height: 232.0,
                    child: PageView(
                      controller: controller,
                      physics: BouncingScrollPhysics(),
                      pageSnapping: true,
                      children: <Widget>[
                        NameAndGender(),
                        PhoneEmailInstagram(),
                        MarriedSpouse(),
                        Children(),
                        ImportantDates(),
                        Notes(),
                        ProfileIcons(),
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
                          splashColor: Color(ColorConstants.primary),
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
                          splashColor: Color(ColorConstants.primary),
                          onPressed: () {
                            onNextPressed(pageState);
                          },
                          child: Text(
                            pageState.pageViewIndex == 6 ? "Save" : "Next",
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
      );
  }

  void onNextPressed(NewContactPageState pageState) {
    if (pageState.pageViewIndex != 6) {
      pageState.onNextPressed();
      controller.animateToPage(currentPageIndex + 1, duration: Duration(milliseconds: 250), curve: Curves.ease);
    }
    if (pageState.pageViewIndex == 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            pageState.onCancelPressed();
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
          return Padding(
            padding: EdgeInsets.all(96.0),
            child: FlareActor("assets/animations/success_check.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "show_check"),
          );
        },
      );
      if (pageState.saveButtonEnabled) {
        pageState.onSavePressed();
      } else {}
    }
  }

  void onBackPressed(NewContactPageState pageState) {
    if (pageState.pageViewIndex == 0) {
      Navigator.of(context).pop();
      pageState.onCancelPressed();
    } else {
      pageState.onBackPressed();
      controller.animateToPage(currentPageIndex - 1, duration: Duration(milliseconds: 250), curve: Curves.ease);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

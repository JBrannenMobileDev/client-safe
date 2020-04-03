import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'NewContactTextField.dart';

class MarriedSpouse extends StatefulWidget {
  @override
  _MarriedSpouseState createState() {
    return _MarriedSpouseState();
  }
}

class _MarriedSpouseState extends State<MarriedSpouse>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  int selectorIndex = 2;
  Map<int, Widget> statuses;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    statuses = <int, Widget>{
      0: Text(Client.RELATIONSHIP_MARRIED,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: selectorIndex == 0 ? FontWeight.w800 : FontWeight.w600,
          fontFamily: 'simple',
          color: Color(selectorIndex == 0
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      1: Text(Client.RELATIONSHIP_ENGAGED,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: selectorIndex == 1 ? FontWeight.w800 : FontWeight.w600,
          fontFamily: 'simple',
          color: Color(selectorIndex == 1
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      2: Text(Client.RELATIONSHIP_SINGLE,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: selectorIndex == 2 ? FontWeight.w800 : FontWeight.w600,
          fontFamily: 'simple',
          color: Color(selectorIndex == 2
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
    };
    return StoreConnector<AppState, NewContactPageState>(
        onInit: (store) {
          firstNameTextController.text = store.state.newContactPageState.spouseFirstName;
          lastNameTextController.text = store.state.newContactPageState.spouseLastName;
        },
        converter: (store) => NewContactPageState.fromStore(store),
        builder: (BuildContext context, NewContactPageState pageState) =>
            Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 26.0, right: 26.0),
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    bottom:
                        getRelationshipIndex(pageState.relationshipStatus) != 2
                            ? 169.0
                            : 0.0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Does " +
                          pageState.newContactFirstName +
                          " have a significant other?",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12.0),
                      width: 250.0,
                      child: CupertinoSlidingSegmentedControl<int>(
                        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                        thumbColor: Color(ColorConstants.getPrimaryColor()),
                        children: statuses,
                        onValueChanged: (int statusIndex) {
                          setState(() {
                            selectorIndex = statusIndex;
                          });
                          pageState.onRelationshipStatusChanged(statusIndex);
                          setState(() {
                            if (statusIndex == 0 || statusIndex == 1) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }
                          });
                          pageState.onRelationshipStatusChanged(statusIndex);
                        },
                        groupValue: selectorIndex,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: getRelationshipIndex(pageState.relationshipStatus) == 2
                    ? 0.0
                    : 1.0,
                duration: Duration(milliseconds: 250),
                child: Container(
                  margin: EdgeInsets.only(top: 72.0),
                  child: Column(
                    children: <Widget>[
                      getRelationshipIndex(pageState.relationshipStatus) == 1 ||
                              getRelationshipIndex(
                                      pageState.relationshipStatus) ==
                                  0
                          ? NewContactTextField(
                              firstNameTextController,
                              "First Name",
                              TextInputType.text,
                              60.0,
                              pageState.onSpouseFirstNameChanged,
                              NewContactPageState.NO_ERROR,
                              TextInputAction.next,
                              _firstNameFocus,
                              onFirstNameAction,
                              TextCapitalization.words,
                              null)
                          : SizedBox(),
                      getRelationshipIndex(pageState.relationshipStatus) == 1 ||
                              getRelationshipIndex(
                                      pageState.relationshipStatus) ==
                                  0
                          ? NewContactTextField(
                              lastNameTextController,
                              "Last Name",
                              TextInputType.text,
                              60.0,
                              pageState.onSpouseLastNameChanged,
                              NewContactPageState.NO_ERROR,
                              TextInputAction.done,
                              _lastNameFocus,
                              onLastNameAction,
                              TextCapitalization.words,
                              null)
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  int getRelationshipIndex(String relationshipStatus) {
    switch (relationshipStatus) {
      case Client.RELATIONSHIP_MARRIED:
        return 0;
      case Client.RELATIONSHIP_ENGAGED:
        return 1;
      case Client.RELATIONSHIP_SINGLE:
        return 2;
    }
    return 2;
  }

  void onFirstNameAction(){
    _firstNameFocus.unfocus();
    FocusScope.of(context).requestFocus(_lastNameFocus);
  }

  void onLastNameAction(){
    _lastNameFocus.unfocus();
  }

  @override
  bool get wantKeepAlive => true;
}

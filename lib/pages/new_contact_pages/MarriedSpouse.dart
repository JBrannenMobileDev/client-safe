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
  final Map<int, Widget> statuses = const <int, Widget>{
    0: Text(Client.RELATIONSHIP_MARRIED),
    1: Text(Client.RELATIONSHIP_ENGAGED),
    2: Text(Client.RELATIONSHIP_SINGLE),
  };

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewContactPageState>(
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
                            ? 172.0
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
                        fontSize: 16.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      width: 250.0,
                      child: CupertinoSegmentedControl<int>(
                        borderColor: Color(ColorConstants.primary),
                        selectedColor: Color(ColorConstants.primary),
                        unselectedColor: Colors.white,
                        children: statuses,
                        onValueChanged: (int statusIndex) {
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
                        groupValue:
                            getRelationshipIndex(pageState.relationshipStatus),
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

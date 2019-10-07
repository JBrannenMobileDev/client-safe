import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'NewContactTextField.dart';

class MarriedSpouse extends StatefulWidget {
  final NewContactPageState pageState;

  MarriedSpouse(this.pageState);

  @override
  _MarriedSpouseState createState() {
    return _MarriedSpouseState(pageState);
  }
}

class _MarriedSpouseState extends State<MarriedSpouse>
    with TickerProviderStateMixin {
  final NewContactPageState pageState;
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  bool _visible = false;
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final Map<int, Widget> statuses = const <int, Widget>{
    0: Text(Client.RELATIONSHIP_MARRIED),
    1: Text(Client.RELATIONSHIP_ENGAGED),
    2: Text(Client.RELATIONSHIP_SINGLE),
  };
  int statusIndex = 2;

  _MarriedSpouseState(this.pageState);

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 250));

    _offsetFloat = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -0.3))
        .animate(_controller);

    _offsetFloat.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 26.0, right: 26.0),
      child: Stack(
        children: <Widget>[
          SlideTransition(
            position: _offsetFloat,
            child: Container(
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
                    margin: EdgeInsets.only(top: 16.0),
                    width: 250.0,
                    child: CupertinoSegmentedControl<int>(
                      borderColor: Color(ColorConstants.primary),
                      selectedColor: Color(ColorConstants.primary),
                      unselectedColor: Colors.white,
                      children: statuses,
                      onValueChanged: (int statusIndex) {
                        pageState.onRelationshipStatusChanged(statusIndex);
                        setState(() {
                          this.statusIndex = statusIndex;
                          if (statusIndex == 0 || statusIndex == 1) {
                            _controller.forward();
                            _visible = true;
                          } else {
                            _controller.reverse();
                            _visible = false;
                          }
                        });
                      },
                      groupValue: statusIndex,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 250),
            child: Container(
              margin: EdgeInsets.only(top: 95.0),
              child: Column(
                children: <Widget>[
                  statusIndex == 1 || statusIndex == 0
                      ? NewContactTextField(
                          firstNameTextController,
                          "First Name",
                          TextInputType.text,
                          65.0,
                          pageState.onSpouseFirstNameChanged)
                      : SizedBox(),
                  statusIndex == 1 || statusIndex == 0
                      ? NewContactTextField(lastNameTextController, "Last Name",
                          TextInputType.text, 65.0, pageState.onSpouseLastNameChanged)
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

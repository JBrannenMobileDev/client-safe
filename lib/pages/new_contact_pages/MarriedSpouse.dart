import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'NewContactTextField.dart';

class MarriedSpouse extends StatefulWidget{


  @override
  _MarriedSpouseState createState() {
    return _MarriedSpouseState();
  }
}

class _MarriedSpouseState extends State<MarriedSpouse> with TickerProviderStateMixin{
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  bool _visible = false;
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Married'),
    1: Text('Engaged'),
    2: Text('Single'),
  };
  int sharedValue = 2;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 250));

    _offsetFloat = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -0.3))
        .animate(_controller);

    _offsetFloat.addListener((){
      setState((){});
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
                    "Does client have significant other?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
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
                      children: children,
                      onValueChanged: (int newValue) {
                        setState(() {
                          sharedValue = newValue;
                          if(newValue == 0 || newValue == 1){
                            _controller.forward();
                            _visible = true;
                          }else{
                            _controller.reverse();
                            _visible = false;
                          }
                        });
                      },
                      groupValue: sharedValue,
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
                  sharedValue == 1 || sharedValue == 0 ? NewContactTextField(firstNameTextController, "Spouse First Name", TextInputType.text) : SizedBox(),
                  sharedValue == 1 || sharedValue == 0 ? NewContactTextField(lastNameTextController, "Spouse Last Name", TextInputType.text) : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
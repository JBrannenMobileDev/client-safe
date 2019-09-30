import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NameAndGender extends StatefulWidget {
  @override
  _NameAndGenderState createState() {
    return _NameAndGenderState();
  }
}

class _NameAndGenderState extends State<NameAndGender> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Male'),
    1: Text('Female'),
    2: Text('Alien'),
  };
  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26.0, right: 26.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
            width: 250.0,
            child: CupertinoSegmentedControl<int>(
              borderColor: Color(ColorConstants.primary),
              selectedColor: Color(ColorConstants.primary),
              unselectedColor: Colors.white,
              children: children,
              onValueChanged: (int newValue) {
                setState(() {
                  sharedValue = newValue;
                });
              },
              groupValue: sharedValue,
            ),
          ),
          SizedBox(
            height: 65.0,
            child: TextField(
              controller: firstNameTextController,
              onChanged: (text) {},
              keyboardType: TextInputType.text,
              style: new TextStyle(
                color: const Color(ColorConstants.primary_black),
                fontSize: 18.0,
              ),
              decoration: new InputDecoration(
                filled: false,
                hintText: "First Name",
                hintStyle: new TextStyle(
                  color: const Color(ColorConstants.primary_black),
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 65.0,
            child: TextField(
              controller: lastNameTextController,
              onChanged: (text) {},
              keyboardType: TextInputType.text,
              style: new TextStyle(
                color: const Color(ColorConstants.primary_black),
                fontSize: 18.0,
              ),
              decoration: new InputDecoration(
                filled: false,
                hintText: "last Name",
                hintStyle: new TextStyle(
                  color: const Color(ColorConstants.primary_black),
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

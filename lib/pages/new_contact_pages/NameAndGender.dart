import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'NewContactTextField.dart';

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
  };
  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26.0, right: 26.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          NewContactTextField(firstNameTextController, "First Name", TextInputType.text),
          NewContactTextField(lastNameTextController, "Last Name", TextInputType.text),
        ],
      ),
    );
  }
}

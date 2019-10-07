import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'NewContactTextField.dart';

class NameAndGender extends StatefulWidget {
  final NewContactPageState pageState;

  NameAndGender(this.pageState);

  @override
  _NameAndGenderState createState() {
    return _NameAndGenderState(pageState);
  }
}

class _NameAndGenderState extends State<NameAndGender> {
  final NewContactPageState pageState;
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final Map<int, Widget> genders = const <int, Widget>{
    0: Text(Client.GENDER_MALE),
    1: Text(Client.GENDER_FEMALE),
  };
  int genderIndex = 1;

  _NameAndGenderState(this.pageState);

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
              children: genders,
              onValueChanged: (int genderIndex) {
                pageState.onGenderSelected(genderIndex);
                setState(() {
                  this.genderIndex = genderIndex;
                });
              },
              groupValue: genderIndex,
            ),
          ),
          NewContactTextField(firstNameTextController, "First Name", TextInputType.text, 65.0, pageState.onClientFirstNameChanged),
          NewContactTextField(lastNameTextController, "Last Name", TextInputType.text, 65.0, pageState.onClientLastNameChanged),
        ],
      ),
    );
  }
}

import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactTextField.dart';

import 'NewContactTextField.dart';

class Notes extends StatefulWidget {
  final NewContactPageState pageState;

  Notes(this.pageState);

  @override
  _Notes createState() {
    return _Notes(pageState);
  }
}

class _Notes extends State<Notes> {
  final NewContactPageState pageState;
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();

  _Notes(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26.0, right: 26.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Text(
              "Do you have any additional information you want to remember about " + pageState.newContactFirstName + "? Interests/Passions?",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
                color: Color(ColorConstants.primary_black),
              ),
            ),
          ),
          NewContactTextField(firstNameTextController, "Notes", TextInputType.multiline, 132.0, pageState.onNotesChanged),
        ],
      ),
    );
  }
}

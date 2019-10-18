import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'NewContactTextField.dart';

class NameAndGender extends StatefulWidget {
  @override
  _NameAndGenderState createState() {
    return _NameAndGenderState();
  }
}

class _NameAndGenderState extends State<NameAndGender>
    with AutomaticKeepAliveClientMixin {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final Map<int, Widget> genders = const <int, Widget>{
    0: Text(Client.GENDER_MALE),
    1: Text(Client.GENDER_FEMALE),
  };

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 24.0),
              width: 250.0,
              child: CupertinoSegmentedControl<int>(
                borderColor: Color(ColorConstants.primary),
                selectedColor: Color(ColorConstants.primary),
                unselectedColor: Colors.white,
                children: genders,
                onValueChanged: (int genderIndex) {
                  pageState.onGenderSelected(genderIndex);
                },
                groupValue: pageState.isFemale ? 1 : 0,
              ),
            ),
            NewContactTextField(
                firstNameTextController,
                "First Name",
                TextInputType.text,

                60.0,
                pageState.onClientFirstNameChanged,
                NewContactPageState.ERROR_FIRST_NAME_MISSING,
                TextInputAction.next,
                _firstNameFocus,
                onFirstNameAction,
                TextCapitalization.words,
                null),
            NewContactTextField(
                lastNameTextController,
                "Last Name",
                TextInputType.text,
                60.0,
                pageState.onClientLastNameChanged,
                NewContactPageState.NO_ERROR,
                TextInputAction.done,
                _lastNameFocus,
                onLastNameAction,
                TextCapitalization.words,
                null),
          ],
        ),
      ),
    );
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

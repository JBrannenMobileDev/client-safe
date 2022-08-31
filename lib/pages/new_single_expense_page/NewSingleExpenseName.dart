import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/dandylightTextField.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';


class NewSingleExpenseName extends StatefulWidget {
  @override
  _NewSingleExpenseName createState() {
    return _NewSingleExpenseName();
  }
}

class _NewSingleExpenseName extends State<NewSingleExpenseName> with AutomaticKeepAliveClientMixin {
  final profileNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewSingleExpensePageState>(
      onInit: (store) {
        profileNameTextController.text = store.state.newSingleExpensePageState?.expenseName;
      },
      converter: (store) => NewSingleExpensePageState.fromStore(store),
      builder: (BuildContext context, NewSingleExpensePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Enter a simple and descriptive name for this single expense. \n\ne.g. (Camera lens) or (SD cards)",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            DandyLightTextField(
                controller: profileNameTextController,
                hintText: "Single expense name",
                inputType: TextInputType.text,
                focusNode: null,
                height: 66.0,
                onTextInputChanged: pageState.onNameChanged,
                keyboardAction: TextInputAction.done,
                capitalization: TextCapitalization.words,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

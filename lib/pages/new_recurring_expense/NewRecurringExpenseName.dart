import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/dandylightTextField.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';


class NewRecurringExpenseName extends StatefulWidget {
  @override
  _NewRecurringExpenseName createState() {
    return _NewRecurringExpenseName();
  }
}

class _NewRecurringExpenseName extends State<NewRecurringExpenseName> with AutomaticKeepAliveClientMixin {
  final profileNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewRecurringExpensePageState>(
      onInit: (store) {
        profileNameTextController.text = store.state.newRecurringExpensePageState?.expenseName;
      },
      converter: (store) => NewRecurringExpensePageState.fromStore(store),
      builder: (BuildContext context, NewRecurringExpensePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Enter a simple and descriptive name for this recurring expense. \n\ne.g. (Lightroom) or (Cell phone plan)",
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
                hintText: "Recurring expense name",
                inputType: TextInputType.text,
                focusNode: null,
                height: 64.0,
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

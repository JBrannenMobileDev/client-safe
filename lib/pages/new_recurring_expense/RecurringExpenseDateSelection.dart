import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class RecurringExpenseDateSelection extends StatefulWidget {

  @override
  _RecurringExpenseDateSelectionState createState() {
    return _RecurringExpenseDateSelectionState();
  }
}

class _RecurringExpenseDateSelectionState extends State<RecurringExpenseDateSelection> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewRecurringExpensePageState>(
      converter: (store) => NewRecurringExpensePageState.fromStore(store),
      builder: (BuildContext context, NewRecurringExpensePageState pageState) =>
      Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Select the date when you started paying for this recurring expense',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32.0),
                alignment: Alignment.center,
                child: TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {
                    DatePicker.showDatePicker(
                        context,
                        dateFormat: 'MMMM dd yyyy',
                        pickerMode: DateTimePickerMode.date,
                        onConfirm: (dateTime, intList) {
                          pageState.onExpenseDateSelected(dateTime);
                        }
                    );
                  },
                  child: pageState.expenseDate != null ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        height: 72.0,
                        width: 72.0,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getBlueLight()),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                            'assets/images/icons/calendar_icon_white.png'),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 2.0, left: 16.0, right: 16.0),
                        alignment: Alignment.center,
                        height: 48.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                              width: 1,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                        ),
                        child: Text(
                          DateFormat('MMM dd, yyyy').format(pageState.expenseDate),
                          style: TextStyle(
                            fontFamily: 'simple',
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPeachDark()),
                          ),
                        ),
                      ),
                    ],
                  ) : Container(
                    padding: EdgeInsets.all(24.0),
                    height: 116.0,
                    width: 116.0,
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getBlueLight()),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                        'assets/images/icons/calendar_icon_white.png'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
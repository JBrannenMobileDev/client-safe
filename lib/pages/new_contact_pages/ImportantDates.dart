import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/HostDetectionUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/rounded_date_picker.dart';

class ImportantDates extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImportantDates();
  }
}

class _ImportantDates extends State<ImportantDates> {
  List<int> _selectedIndexes = List();
  List<String> _chipLabels = ["Anniversary", "Pregnancy due date", "Graduation", "Birthday", "Other"];

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await RoundedDatePicker.show(context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 1),
          lastDate: DateTime(DateTime.now().year + 1),
          borderRadius: 16);
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    return Padding(
      padding: EdgeInsets.only(left: 26.0, right: 26.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Do you know any important dates for Client?",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600,
              color: Color(ColorConstants.primary_black),
            ),
          ),
          Text(
            "These will be used to help remind you of job opportunities.",
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
            child: Wrap(
              children: List<Widget>.generate(
                _chipLabels.length,
                (int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        _chipLabels.elementAt(index),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: _selectedIndexes.contains(index) ? FontWeight.w600 : FontWeight.w400,
                          color: _selectedIndexes.contains(index) ? Colors.white : Color(ColorConstants.primary_black),
                        ),
                      ),
                      backgroundColor: Color(ColorConstants.primary_bg_grey),
                      selectedColor: Color(ColorConstants.primary),
                      selected: _selectedIndexes.contains(index),
                      onSelected: (bool selected) {
                        setState(() {
                          if(selected){
                            _selectedIndexes.add(index);
                            HostDetectionUtil.isIos(context) ? DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                }, currentTime: DateTime.now(), locale: LocaleType.en)
                                : _selectDate(context);
                          }else{
                            _selectedIndexes.remove(index);
                          }
                        });
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

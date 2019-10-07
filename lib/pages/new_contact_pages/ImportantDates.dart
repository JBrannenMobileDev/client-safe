import 'dart:async';

import 'package:client_safe/models/ImportantDate.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/HostDetectionUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/rounded_date_picker.dart';

import 'NewContactPageState.dart';

class ImportantDates extends StatefulWidget {
  final NewContactPageState pageState;

  ImportantDates(this.pageState);

  @override
  State<StatefulWidget> createState() {
    return _ImportantDates(pageState);
  }

  static String getDateForChipIndex(int chipIndex, NewContactPageState pageState) {
    String desiredDate = "";
    for(ImportantDate date in pageState.importantDates){
      if(date.chipIndex == chipIndex) desiredDate = date.date.toString();
    }
    return desiredDate;
  }
}

class _ImportantDates extends State<ImportantDates> {
  final NewContactPageState pageState;
  List<int> _selectedIndexes = List();
  List<String> _chipLabels = [
    ImportantDate.TYPE_ANNIVERSARY,
    ImportantDate.TYPE_GRADUATION,
    ImportantDate.TYPE_PREGNANCY_DUE_DATE,
    ImportantDate.TYPE_BIRTHDAY,
  ];

  _ImportantDates(this.pageState);

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    Future<Null> _selectDate(BuildContext context, NewContactPageState pageState, String type, int chipIndex) async {
      final DateTime picked = await RoundedDatePicker.show(context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 2),
          lastDate: DateTime(DateTime.now().year + 10),
          borderRadius: 16);
      if (picked != null && picked != selectedDate)
        _onConfirmedImportantDate(picked, pageState, type, chipIndex);
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
            "Do you know any important dates for " + pageState.newContactFirstName + "?",
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
            margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(
                _chipLabels.length,
                (int index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        child: ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                _chipLabels.elementAt(index),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: _selectedIndexes.contains(index)
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: _selectedIndexes.contains(index)
                                      ? Colors.white
                                      : Color(ColorConstants.primary_black),
                                ),
                              ),
                              _selectedIndexes.contains(index)
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Icon(Icons.close),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          backgroundColor:
                              Color(ColorConstants.primary_bg_grey),
                          selectedColor: Color(ColorConstants.primary),
                          selected: _selectedIndexes.contains(index),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedIndexes.add(index);
                                HostDetectionUtil.isIos(context)
                                    ? DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(DateTime.now().year - 2),
                                        maxTime: DateTime(DateTime.now().year + 10),
                                        onConfirm: (date) {
                                          _onConfirmedImportantDate(date, pageState, _chipLabels.elementAt(index), index);
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en)
                                    : _selectDate(context, pageState, _chipLabels.elementAt(index), index);
                              } else {
                                _selectedIndexes.remove(index);
                                _onRemoveImportantDate(index);
                              }
                            });
                          },
                        ),
                      ),
                      _selectedIndexes.contains(index) ? Container(
                        margin: EdgeInsets.only(top: 44.0),
                        child: Text(
                          ImportantDates.getDateForChipIndex(index, pageState),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ) : Container(
                        margin: EdgeInsets.only(top: 44.0),
                        child: Text(
                          "",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirmedImportantDate(DateTime importantDate, NewContactPageState pageState, String type, int chipIndex){
    pageState.onImportantDateAdded(ImportantDate(importantDate, type, chipIndex));
  }

  void _onRemoveImportantDate(int chipIndex){
    pageState.onImportantDateRemoved(chipIndex);
  }
}

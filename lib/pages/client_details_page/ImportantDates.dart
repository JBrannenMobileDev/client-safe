import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/ImportantDate.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../widgets/TextDandyLight.dart';


class ImportantDates extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImportantDates();
  }

  static String getDateForChipIndex(
      int chipIndex, ClientDetailsPageState pageState) {
    DateTime desiredDate = DateTime.now();
    for (ImportantDate date in pageState.importantDates) {
      if (date.chipIndex == chipIndex) desiredDate = date.date;
    }
    return DateFormat('MMM d, yyyy').format(desiredDate);
  }
}

class _ImportantDates extends State<ImportantDates> {
  List<String> _chipLabels = [
    ImportantDate.TYPE_ANNIVERSARY,
    ImportantDate.TYPE_ENGAGEMENT,
    ImportantDate.TYPE_PREGNANCY_DUE_DATE,
    ImportantDate.TYPE_GRADUATION,
    ImportantDate.TYPE_BIRTHDAY,
    ImportantDate.TYPE_WEDDING,
  ];

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ClientDetailsPageState>(
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) => Container(
        padding: EdgeInsets.only(top: 4.0, left: 20, right: 20),
        height: 448,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            color: Color(ColorConstants.getPrimaryWhite())),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Done',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 32.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Important Dates',
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 16.0),
              child:  TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: "Do you know any important dates for " +
                        pageState.client.firstName +
                        "?",
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 16.0),
              child:  TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: "These will be used to help remind you of job opportunities.",
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
            ),
            Container(
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
                                TextDandyLight(
                                  type: TextDandyLight.SMALL_TEXT,
                                  text: _chipLabels.elementAt(index),
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                                isSelected(index, pageState)
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 4.0),
                                        child: Icon(Icons.close, size: 20,),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            backgroundColor:
                                Color(ColorConstants.primary_bg_grey),
                            selectedColor: Color(ColorConstants.getPrimaryColor()),
                            selected: isSelected(index, pageState),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(
                                              DateTime.now().year - 115),
                                          maxTime: DateTime(
                                              DateTime.now().year + 5,
                                              DateTime.now().month,
                                              DateTime.now().day),
                                          onConfirm: (date) {
                                          _onConfirmedImportantDate(
                                              date,
                                              pageState,
                                              _chipLabels.elementAt(index),
                                              index);
                                        },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                } else {
                                  pageState.onImportantDateRemoved(index);
                                }
                              });
                            },
                          ),
                        ),
                        isSelected(index, pageState)
                            ? Container(
                                margin: EdgeInsets.only(top: 32.0),
                                child: TextDandyLight(
                                  type: TextDandyLight.EXTRA_SMALL_TEXT,
                                  text: ImportantDates.getDateForChipIndex(
                                      index, pageState),
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 32.0),
                                child: Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    color: Color(ColorConstants.getPrimaryBlack()),
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
      ),
    );
  }

  void _onConfirmedImportantDate(DateTime importantDate,
      ClientDetailsPageState pageState, String type, int chipIndex) {
    pageState.onImportantDateAdded(ImportantDate(date: importantDate, type: type, chipIndex: chipIndex));
  }

  bool isSelected(int index, ClientDetailsPageState pageState) {
    bool isSelected = false;
    for (ImportantDate importantDate in pageState.importantDates) {
      if (importantDate.chipIndex == index) isSelected = true;
    }
    return isSelected;
  }
}

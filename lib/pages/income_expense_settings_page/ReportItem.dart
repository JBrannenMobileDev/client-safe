import 'package:dandylight/models/Report.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_csv/to_csv.dart' as export_csv;

import '../../../utils/styles/Styles.dart';

class ReportItem extends StatelessWidget{
  final Report report;
  const ReportItem({Key key, this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () {
        export_csv.myCSV(report.header, report.rows, 'IncomeAndExpenses${report.year}.csv');
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 18.0),
        child: TextDandyLight(
          type: TextDandyLight.LARGE_TEXT,
          text: report.year.toString(),
        )
      ),
    );
  }
}
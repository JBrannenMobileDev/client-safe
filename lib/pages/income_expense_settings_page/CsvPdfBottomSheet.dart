import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../models/Report.dart';
import 'package:to_csv/to_csv.dart' as export_csv;



class CsvPdfBottomSheet extends StatefulWidget {
  final Report report;
  const CsvPdfBottomSheet({Key key, this.report}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _CsvPdfBottomSheetState(report);
  }
}

class _CsvPdfBottomSheetState extends State<CsvPdfBottomSheet> with TickerProviderStateMixin {
  final Report report;

  _CsvPdfBottomSheetState(this.report);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, IncomeAndExpenseSettingsPageState>(
    converter: (Store<AppState> store) => IncomeAndExpenseSettingsPageState.fromStore(store),
    builder: (BuildContext context, IncomeAndExpenseSettingsPageState pageState) =>
         Container(
           height: 296,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
             child: Column(
               children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Document Type',
                    ),
                  ),
                 Container(
                   margin: const EdgeInsets.only(top: 16, bottom: 48, left: 16, right: 16),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       GestureDetector(
                         onTap: () {

                         },
                         child: Container(
                           alignment: Alignment.center,
                           padding: const EdgeInsets.all(22),
                           height: 116,
                           width: 116,
                           decoration: BoxDecoration(
                               borderRadius: const BorderRadius.all(Radius.circular(16)),
                               color: Color(ColorConstants.getPrimaryGreyLight())
                           ),
                           child: Image.asset('assets/images/icons/pdf.png', color: Color(ColorConstants.getPrimaryBlack()),),
                         ),
                       ),
                       GestureDetector(
                         onTap: () {
                           export_csv.myCSV(report.header, report.rows, 'IncomeAndExpenses${report.year}.csv');
                         },
                         child: Container(
                           alignment: Alignment.center,
                           padding: const EdgeInsets.all(22),
                           height: 116,
                           width: 116,
                           decoration: BoxDecoration(
                               borderRadius: const BorderRadius.all(Radius.circular(16)),
                               color: Color(ColorConstants.getPrimaryGreyLight())
                           ),
                           child: Image.asset('assets/images/icons/csv.png', color: Color(ColorConstants.getPrimaryBlack()),)
                         ),
                       )
                     ],
                   ),
                 ),
               ],
             ),
         ),
    );
}
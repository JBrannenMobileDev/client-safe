import 'package:dandylight/models/Report.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/styles/Styles.dart';
import '../../utils/ColorConstants.dart';
import 'CsvPdfBottomSheet.dart';

class ReportItem extends StatelessWidget{
  final Report? report;
  const ReportItem({Key? key, this.report}) : super(key: key);

  void _showAppUpdateBottomSheet(BuildContext context, Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return CsvPdfBottomSheet(report: report);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () {
        _showAppUpdateBottomSheet(context, report!);
      },
      child: Container(
        height: 54,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Color(ColorConstants.getPeachDark())
        ),
        margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 26,
              width: 26,
              child: Image.asset('assets/images/icons/download.png', color: Color(ColorConstants.getPrimaryWhite()),),
            ),
            const SizedBox(width: 32),
            TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: report!.year!.toString(),
              color: Color(ColorConstants.getPrimaryWhite()),
            )
          ],
        )
      ),
    );
  }
}
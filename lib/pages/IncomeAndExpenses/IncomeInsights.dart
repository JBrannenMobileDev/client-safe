
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../utils/TextFormatterUtil.dart';
import '../../widgets/TextDandyLight.dart';

class IncomeInsights extends StatelessWidget {
  const IncomeInsights({Key? key, this.pageState}) : super(key: key);

  final IncomeAndExpensesPageState? pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 128.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - (21) - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      borderRadius: const BorderRadius.all(Radius.circular(12.0))),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: 'This Month',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 42.0),
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: TextFormatterUtil.formatSimpleCurrency(pageState!.thisMonthIncome!),
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - (21) - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      borderRadius: const BorderRadius.all(Radius.circular(12.0))),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: 'Last Month',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 42.0),
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: TextFormatterUtil.formatSimpleCurrency(pageState!.lastMonthIncome!),
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

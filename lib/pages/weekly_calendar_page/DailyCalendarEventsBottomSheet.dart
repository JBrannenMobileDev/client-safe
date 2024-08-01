import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/CalendarUtil.dart';
import 'WeeklyCalendarPageState.dart';


class DailyCalendarEventsBottomSheet extends StatefulWidget {
  final DateTime day;

  const DailyCalendarEventsBottomSheet(this.day, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DailyCalendarEventsBottomSheetState(day);
  }
}

class _DailyCalendarEventsBottomSheetState extends State<DailyCalendarEventsBottomSheet> with TickerProviderStateMixin {
  final DateTime day;

  _DailyCalendarEventsBottomSheetState(this.day);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, WeeklyCalendarPageState>(
    converter: (Store<AppState> store) => WeeklyCalendarPageState.fromStore(store),
    builder: (BuildContext context, WeeklyCalendarPageState pageState) =>
         Container(
           height: 632,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0),
             child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: const EdgeInsets.only(top: 24, bottom: 16),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: DateFormat('EEE, MMM d, yyyy').format(day),
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.getPrimaryBlack()),
                       ),
                     ),
                     Expanded(
                       child: CalendarUtil.buildEventList(
                         day,
                         pageState.eventList,
                         day.year,
                         day.month,
                         day.day,
                         pageState.jobs!,
                       ),
                     ),
                   ],
           ),
         ),
    );
}
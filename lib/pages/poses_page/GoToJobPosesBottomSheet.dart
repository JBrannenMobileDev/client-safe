import 'package:dandylight/pages/poses_page/PosesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../models/Job.dart';


class GoToJobPosesBottomSheet extends StatefulWidget {
  final Job job;
  final int numOfPops;

  GoToJobPosesBottomSheet(this.job, this.numOfPops);

  @override
  State<StatefulWidget> createState() {
    return _GoToJobPosesBottomSheetState(job, numOfPops);
  }
}

class _GoToJobPosesBottomSheetState extends State<GoToJobPosesBottomSheet> with TickerProviderStateMixin {
  final Job job;
  final int numOfPops;

  _GoToJobPosesBottomSheetState(this.job, this.numOfPops);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        for(int index = 0; index < numOfPops; index++) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        height: 86,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(ColorConstants.getPeachDark())),
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24),
        child: Container(
            alignment: Alignment.topCenter,
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              color: Color(ColorConstants.getPrimaryWhite()),
              text: 'BACK TO JOB',
            ),
        ),
      ),
    );
  }
}
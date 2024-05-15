import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';
import '../GettingStartedBottomSheet.dart';

class GettingStartedProgress extends StatelessWidget {
  const GettingStartedProgress({Key? key, this.pageState}) : super(key: key);

  final DashboardPageState? pageState;

  void _showGettingStartedBottomSheet(BuildContext context, DashboardPageState pageState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const GettingStartedBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
  converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
  builder: (BuildContext context, DashboardPageState pageState) =>
      GestureDetector(
        onTap: () {
          _showGettingStartedBottomSheet(context, pageState);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 2),
          height: 76.0,
          decoration: BoxDecoration(
              color: Color(ColorConstants.getBlueDark()),
              borderRadius: const BorderRadius.all(Radius.circular(12.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Getting Started Progress',
                color: Color(ColorConstants.getPrimaryWhite()),
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: pageState.profile?.progress.getProgressValue(),
                        borderRadius: BorderRadius.circular(8),
                        color: Color(ColorConstants.getPrimaryWhite()),
                        backgroundColor: Color(ColorConstants.getPrimaryGreyMedium()),
                      )
                    ),
                    Container(
                      width: 48,
                      margin: const EdgeInsets.only(left: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: '${pageState.profile?.progress.getProgressString()}%',
                        isBold: true,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
}

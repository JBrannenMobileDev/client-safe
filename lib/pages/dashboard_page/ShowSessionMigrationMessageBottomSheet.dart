import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/ColorConstants.dart';
import 'DashboardPageState.dart';

class ShowSessionMigrationMessageBottomSheet extends StatelessWidget {
  final Function? doneAction;
  const ShowSessionMigrationMessageBottomSheet({super.key, this.doneAction});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 564,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0)),
            color: Color(ColorConstants.getPrimaryWhite())),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
        child: Body()
    );
  }
}

class Body extends StatefulWidget {
  @override
  _body createState() {
    return _body();
  }
}

class _body extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DashboardPageState>(
        converter: (store) => DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) =>
    Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                        text: 'WARNING',
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Important Notice',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        textAlign: TextAlign.center,
                        text: 'In preparation for our new feature, Automated Booking, we have made some changes. We are replacing Job types and Price packages with a single type called Session Type.',
                      ),
                    ),
                    Container(
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        textAlign: TextAlign.center,
                        text: '\nTo ease you into this new change, please take a few minutes to fill in the missing data on the Session Types that we generated for you based on your previous Job Types.',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageState.updateSessionMigrationMessageRead!();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24, top: 32),
                        alignment: Alignment.center,
                        height: 48,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(ColorConstants.getPeachDark()),
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'I READ THE NOTICE',
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 48,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'READ LATER',
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    )
                  ],
              ),
      )
    );
  }
}
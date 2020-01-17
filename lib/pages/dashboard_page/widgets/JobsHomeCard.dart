
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/BaseHomeCard.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class JobsHomeCard extends StatelessWidget {
  JobsHomeCard({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
            margin: EdgeInsets.only(top: 60.0),
            height: Device.get().isIphoneX ? 110.0 : 90.0,
            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
          ),
          BaseHomeCard(
            cardTitle: "Upcoming Jobs",
            pageState: pageState,
          ),
        ],
      ),
    );
  }
}

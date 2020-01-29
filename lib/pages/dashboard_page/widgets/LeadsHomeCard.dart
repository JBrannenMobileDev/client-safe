import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'LeadItem.dart';

class LeadsHomeCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  LeadsHomeCard({
    this.cardTitle,
    this.pageState});

  final String cardTitle;
  final DashboardPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        color: Color(ColorConstants.getPrimaryBackgroundGrey()),
    ),
    child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        cardTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Blackjack',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      Text(
                        "View all",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      )
                    ],
                  ),
                ),
                pageState.potentialJobs.length > 0 ? ListView.builder(
                  padding: EdgeInsets.only(top:0.0, bottom: 8.0),
                    reverse: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: _listKey,
                    itemCount: pageState.potentialJobs.length,
                    itemBuilder: _buildItem,
                  ) : Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 8.0, left: 26.0, right: 26.0),
                  height: 64.0,
                  child: Text(
                    "You do not have any leads. If you start a job and have not received a signed contract, that job will appear here as a lead.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
    ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return LeadItem(job: pageState.potentialJobs.elementAt(index));
  }
}
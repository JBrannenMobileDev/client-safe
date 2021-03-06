import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
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
    child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        cardTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          pageState.onViewAllHideLeadsSelected();
                        },
                        child: Text(
                          pageState.recentLeads.length > 3 ? (pageState
                              .isLeadsMinimized ? 'View all (' + pageState.recentLeads.length.toString() + ')' : 'Hide') : '',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w400,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pageState.recentLeads.length > 0 ? ListView.builder(
                  padding: EdgeInsets.only(top:0.0, bottom: 16.0),
                    reverse: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: _listKey,
                    itemCount: pageState.isLeadsMinimized ? (pageState.recentLeads.length > 3? pageState.recentLeads.sublist(0, 3).length : pageState.recentLeads.length)
        : pageState.recentLeads.length,
                    itemBuilder: _buildItem,
                  ) : Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 26.0, left: 16.0, right: 16.0),
                  height: 64.0,
                  child: Text(
                    "You do not have any leads. New clients without any jobs started will show up here.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
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
    return LeadItem(client: pageState.recentLeads.elementAt(index), pageState: pageState);
  }
}
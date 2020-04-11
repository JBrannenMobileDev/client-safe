import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';


class UnpaidInvoicesCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  UnpaidInvoicesCard({
    this.pageState});

  final DashboardPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
        decoration: BoxDecoration(
        color: Color(ColorConstants.getPrimaryBackgroundGrey()),
    ),
    child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: 200.0,
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Unpaid Invoices',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Blackjack',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ],
                  ),
                ),
                0 > 0 ? ListView.builder(
                  padding: EdgeInsets.only(top:0.0, bottom: 16.0),
                    reverse: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: _listKey,
                    itemCount: 0,
                    itemBuilder: _buildItem,
                  ) : Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 26.0, left: 26.0, right: 26.0),
                  height: 64.0,
                  child: Text(
                    'You have zero unpaid invoices.',
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
    return LeadItem(client: pageState.recentLeads.elementAt(index), pageState: pageState);
  }
}
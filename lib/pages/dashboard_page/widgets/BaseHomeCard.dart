import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';

class BaseHomeCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  BaseHomeCard({
    this.cardTitle,
    this.listItemWidget});

  final String cardTitle;
  final Widget listItemWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        decoration: new BoxDecoration(
            color: Color(ColorConstants.white),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cardTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w800,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Text(
                    "View all",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                reverse: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                key: _listKey,
                //                itemCount: pageState.currentJobs.length < 6 ? pageState.currentJobs.length : 5,
                itemCount: 2,
                itemBuilder: _buildItem,
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
//    return JobListItem(job: pageState.currentJobs.elementAt(index));
    return listItemWidget;
  }

}
import 'package:client_safe/pages/IncomeAndExpenses/InvoiceItem.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class DocumentsCard extends StatelessWidget {
  DocumentsCard({this.pageState});

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 26.0),
      child: Container(
        width: double.maxFinite,
        height: pageState.documents.length == 0 ? 144.0 : 208.0,
        margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 0.0),
        decoration: new BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(26.0, 10.0, 26.0, 0.0),
                    child: Text(
                      'Documents',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w800,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                ],
              ),
              pageState.documents.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 0.0, bottom: 16.0),
                      reverse: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      key: _listKey,
                      itemCount: pageState.documents.length,
                      itemBuilder: _buildItem,
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 26.0, right: 26.0),
                      height: 64.0,
                      child: Text(
                        'No documents have been added to this job yet.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
            ]),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = pageState.documents.elementAt(index);

    return FlatButton(
      onPressed: null,
      child: Container(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: item.buildIconItem(context),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: item.buildTitle(context),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(right: 12.0),
                height: 24.0,
                width: 24.0,
                child: Image.asset('assets/images/icons/trash_icon_peach.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

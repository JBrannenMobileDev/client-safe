import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FollowupSentItem extends StatefulWidget {
  final double scrollPosition;

  FollowupSentItem({
    this.scrollPosition
  });

  @override
  State<StatefulWidget> createState() {
    return _FollowupSentItemState();
  }

}

class _FollowupSentItemState extends State<FollowupSentItem>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, JobDetailsPageState>(
  converter: (Store<AppState> store) =>JobDetailsPageState.fromStore(store),
  builder: (BuildContext context, JobDetailsPageState pageState) => Container(
      height: 172.0,
      width: 172.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(

            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 56.0),
                height: 2.0,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              Container(
                margin: EdgeInsets.only(right: 32.0),
                height: 112.0,
                width: 112.0,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(56.0),
                  image: DecorationImage(
                    image: ImageUtil.getJobStageImage(1),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  margin: EdgeInsets.only(top: 40.0, right: 56.0),
                  height: 36.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ImageUtil.getJobStageCompleteIcon(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Followup sent?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    color: Color(
                        ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Text(
                  'Send followup to complete this stage.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    color: Color(
                        ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
              Container(
                width: 104.0,
                height: 38.0,
                margin: EdgeInsets.only(top: 76.0),
                padding: EdgeInsets.only(top: 4.0, left: 16.0, bottom: 4.0, right: 8.0),
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(8.0),
                    color: Colors.black12
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.message,
                      color: Color(
                          ColorConstants.getPrimaryWhite()),
                      size: 24.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Send',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: Color(
                              ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
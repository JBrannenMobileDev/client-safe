import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class DepositReceivedItem extends StatefulWidget {
  final double scrollPosition;

  DepositReceivedItem({this.scrollPosition});

  @override
  State<StatefulWidget> createState() {
    return _DepositReceivedItemState();
  }
}

class _DepositReceivedItemState extends State<DepositReceivedItem> with TickerProviderStateMixin{
  AnimationController _controller;
  AnimationController _repeatController;
  Animation<double> _circleOpacity;
  Animation<double> _circleSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _repeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _circleOpacity =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
          parent: _repeatController,
          curve: Curves.fastOutSlowIn,
        ));
    _circleSize =
        Tween<double>(begin: 112.0, end: 172.0).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
        ));
//    _circleSize.addListener(() => this.setState(() {}));
//    _controller.repeat();
//    _repeatController.repeat();
  }

  @override
  void dispose() {
    _repeatController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
        converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
        builder: (BuildContext context, JobDetailsPageState pageState) =>
            Container(
              width: 196.0,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 32.0),
                    height: 2.0,
                    color: Color(ColorConstants.getPrimaryDarkColor()),
                  ),
//                  FadeTransition(
//                    opacity: _circleOpacity,
//                    child: Container(
//                      margin: EdgeInsets.only(bottom: 32.0),
//                      alignment: Alignment.center,
//                      height: _circleSize.value,
//                      width: _circleSize.value,
//                      decoration: new BoxDecoration(
//                        color: Colors.white30,
//                        shape: BoxShape.circle,
//                      ),
//                    ),
//                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 32.0, right: 16.0, left: 16.0),
                    height: 112.0,
                    width: 112.0,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(56.0),
                      image: DecorationImage(
                        image: ImageUtil.getJobStageImage(4),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
//                  Opacity(
//                    opacity: 0.5,
//                    child: Container(
//                      margin: EdgeInsets.only(bottom: 32.0),
//                      height: 36.0,
//                      decoration: BoxDecoration(
//                        image: DecorationImage(
//                          image: ImageUtil.getJobStageCompleteIcon(),
//                          fit: BoxFit.contain,
//                        ),
//                      ),
//                    ),
//                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 42.0, top: 188.0),
                        child: Text(
                          'Deposit received?',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
                            color: Color(ColorConstants.getPrimaryDarkColor()),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 42.0, top: 8.0),
                        child: Text(
                          'Receive a deposit to complete this stage.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryDarkColor()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      );
  }
}
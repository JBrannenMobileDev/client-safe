import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ContractSentItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContractSentItemState();
  }
}

class _ContractSentItemState extends State<ContractSentItem>
    with TickerProviderStateMixin{
  AnimationController _controller;
  AnimationController _repeatController;
  Animation<double> _circleOpacity;
  Animation<double> _circleSize;

  GlobalKey key = GlobalKey();
  RenderBox box;
  Offset position;
  double xOffset = 0;

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
        onDidChange: (pageState) => {
          if(key.currentContext != null){
            box = key.currentContext.findRenderObject(),
            position = box.localToGlobal(Offset.zero),
            xOffset = position.dx,
          },
        },
        converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
        builder: (BuildContext context, JobDetailsPageState pageState) =>
            Container(
              key: key,
              width: 156.0,
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
                      height: 72.0,
                      width: 72.0,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(56.0),
                        image: DecorationImage(
                          image: ImageUtil.getJobStageImage(2),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  Opacity(
                    opacity: .5,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 32.0),
                      height: 24.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: ImageUtil.getJobStageCompleteIcon(),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 44.0, top: 172.0),
                        child: Text(
                          'Contract sent?',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
                            color: Color(ColorConstants.getPrimaryDarkColor()),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 44.0, top: 8.0),
                        child: Text(
                          'Send a contract to complete this stage.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 10.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryDarkColor()),
                          ),
                        ),
                      ),
                      Container(
                        width: 84.0,
                        height: 28.0,
                        margin: EdgeInsets.only(left: 44.0, top: 8.0),
                        padding: EdgeInsets.only(top: 4.0, left: 16.0, bottom: 4.0, right: 8.0),
                        decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(8.0),
                            color: Color(ColorConstants.getPrimaryDarkColor()),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.message,
                              color: Color(ColorConstants.getPrimaryColor()),
                              size: 16.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Send',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPrimaryColor()),
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

  double _getCircleWidth(int xOffset) {
    if(xOffset <= 26){
      double result = (112 - ((26-xOffset)*0.5)).roundToDouble();
      if(result < 64) result = 64;
      return result;
    }
    if(xOffset > 26){
      double result = 112 - ((xOffset - 26)*0.5);
      if(result < 64) result = 64.0;
      return result;
    }

    return 64.roundToDouble();
  }

  _getCheckHeight(double xOffset) {
    if(xOffset <= 26){
      double result = (32 - ((26-xOffset)*0.175)).roundToDouble();
      if(result < 16) result = 16;
      return result;
    }
    if(xOffset > 26){
      double result = 32 - ((xOffset - 26)*0.175);
      if(result < 16) result = 16.0;
      return result;
    }

    return 16.roundToDouble();
  }
}
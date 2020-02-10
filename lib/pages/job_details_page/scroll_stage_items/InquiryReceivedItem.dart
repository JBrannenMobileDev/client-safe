import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InquiryReceivedItem extends StatelessWidget{
  final double scrollPosition;

  InquiryReceivedItem({
    this.scrollPosition
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    image: ImageUtil.getJobStageImage(0),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Opacity(
                opacity: 1,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 6.0, left: 84.0),
                  height: 24.0,
                  width: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.all(2.0),
                  child: Container(
                    height: 10.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: ImageUtil.getJobStageCompleteIcon(),
                        fit: BoxFit.contain,
                      ),
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
                  'Inquiry received!',
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
            ],
          ),
        ],
      ),
    );
  }

}
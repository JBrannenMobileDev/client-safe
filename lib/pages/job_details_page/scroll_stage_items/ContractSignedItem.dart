import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContractSignedItem extends StatelessWidget{
  final double scrollPosition;

  ContractSignedItem({
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
                    image: ImageUtil.getJobStageImage(3),
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
                  'Contract Signed?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    color: Colors.black26,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Text(
                  'Receive a signed contract to complete this stage.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    color: Colors.black26,
                  ),
                ),
              ),
              Container(
                width: 124.0,
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
                      Icons.assignment,
                      color: Colors.black26,
                      size: 24.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Resend',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
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
    );
  }

}
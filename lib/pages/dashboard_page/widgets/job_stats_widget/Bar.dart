import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class Bar extends StatelessWidget{
  Bar({this.num, this.height});

  final int num;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            num.toString(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                color: const Color(ColorConstants.primary),
            ),
          ),
          Container(
            height: height,
            width: 42.0,
            decoration: BoxDecoration(
              color: const Color(ColorConstants.primary),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
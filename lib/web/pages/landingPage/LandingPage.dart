import 'package:flutter/material.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/ImageUtil.dart';
import '../../../widgets/TextDandyLight.dart';

class LandingPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) =>  Scaffold(
    backgroundColor: Color(ColorConstants.getBlueLight()),
    body: Stack(
      children: [
        // Container(
        //   width: double.infinity,
        //   child: Image.asset(ImageUtil.LOGIN_BG_BLUE_MOUNTAIN,fit: BoxFit.fill),
        // ),
        // Container(
        //   width: double.infinity,
        //   child: Image.asset(ImageUtil.LOGIN_BG_PEACH_DARK_MOUNTAIN, fit: BoxFit.fill),
        // ),
        // Container(
        //   width: double.infinity,
        //   child: Image.asset(ImageUtil.LOGIN_BG_PEACH_MOUNTAIN, fit: BoxFit.fill),
        // ),
        Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 78),
                    child: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontSize: 144,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants
                            .getPrimaryWhite())
                            .withOpacity(1.0),
                      ),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                      child: Text(
                        'DandyLight',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 229.0, top: 0.0),
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: AssetImage(
                            ImageUtil.LOGIN_BG_LOGO_FLOWER),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: TextDandyLight(
                  text: "Website Coming soon!",
                  type: TextDandyLight.LARGE_TEXT,
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );

}
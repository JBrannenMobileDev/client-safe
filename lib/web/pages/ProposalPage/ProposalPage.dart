import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';

import '../../../utils/ColorConstants.dart';
import 'DetailsPage.dart';

class ProposalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignContractPageState();
  }
}

class _SignContractPageState extends State<ProposalPage> {

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          body: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Container(
                color: Color(ColorConstants.getPrimaryWhite()),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 1080,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 225.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/backgrounds/bannerImage.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(left: 62.5),
                          //   child: Material(
                          //     elevation: 4,
                          //     child: Container(
                          //       alignment: Alignment.centerLeft,
                          //       height: 175,
                          //       width: 175,
                          //       child: Image.asset("images/backgrounds/sample_brand.png"),
                          //     ),
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(left: 37.5),
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                boxShadow: ElevationToShadow[4],
                                shape: BoxShape.circle,
                                color: Color(ColorConstants.getPeachDark())
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 200),
                                child: TextDandyLight(
                                  type: TextDandyLight.EXTRA_LARGE_TEXT,
                                  text: 'Vintage Vibes Photography',
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                  addShadow: true,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 200),
                                child: TextDandyLight(
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: 'Jason Bent',
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                  addShadow: true,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 64,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 64,
                                    width: 200,
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Details',
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 64,
                                    width: 200,
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Contract',
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 64,
                                    width: 200,
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Invoice',
                                    ),
                                  ),
                                ],
                              ),
                          ),
                          DetailsPage()
                        ],
                      ),
                  ],
                ),
              ),
          )
      );
}
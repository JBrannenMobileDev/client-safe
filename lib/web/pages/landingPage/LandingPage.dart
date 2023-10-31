import 'package:dandylight/models/FontTheme.dart';
import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/ImageUtil.dart';
import '../../../widgets/TextDandyLight.dart';

class LandingPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  static const String PRICING = 'pricing';
  static const String HOME = 'home';
  static const String BLOG = 'blog';
  static const String ABOUT = 'about';

  String selectedPage = HOME;
  bool isHoveredPricing = false;
  bool isHoveredBlog = false;
  bool isHoveredAbout = false;
  bool isHoveredApple = false;
  bool isHoveredAndroid = false;
  bool isCollapsed = false;

  List<Widget> infoWidgets = [];


  @override
  void initState() {
    super.initState();
    infoWidgets = buildInfoWidgets();
  }

  @override
  Widget build(BuildContext context) =>  Scaffold(
    backgroundColor: Color(ColorConstants.getPrimaryWhite()),
    //1
    body: CustomScrollView(
      slivers: <Widget>[
        SliverLayoutBuilder(
          builder: (BuildContext context, constraints) {
            if(constraints.scrollOffset > 450) {
              if(!isCollapsed) {
                isCollapsed = true;
              }
            } else {
              if(isCollapsed) {
                isCollapsed = false;
              }
            }
            return SliverAppBar(
              backgroundColor: Color(ColorConstants.getBlueDark()),
              expandedHeight: 550.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 72),
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize: 36,
                              fontFamily: FontTheme.MONTSERRAT,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                            child: Text(
                              'All-in-one solution to\nWOW your clients with professionalism',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                final url = Uri.parse("https://apps.apple.com/app/id6444910643",);
                                launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Container(
                                height: 84,
                                width: 264,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(48),
                                    color: Color(ColorConstants.getPrimaryBlack())
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 4),
                                      height: 48.0,
                                      child: Image.asset(ImageUtil.WEBSITE_APPLE_STORE, height: 64),
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.LARGE_TEXT,
                                      text: 'DOWNLOAD',
                                      isBold: true,
                                      fontFamily: FontTheme.MontserratAlternativesRegular,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 32),
                            GestureDetector(
                              onTap: () {
                                final url = Uri.parse("https://play.google.com/store/apps/details?id=com.dandylight.mobile");
                                launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Container(
                                height: 84,
                                width: 264,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(48),
                                    color: Color(ColorConstants.getPrimaryBlack())
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 0.0, top: 0.0),
                                      height: 48.0,
                                      child: Image.asset(ImageUtil.WEBSITE_GOOGLE_PLAY, height: 64),
                                    ),
                                    TextDandyLight(
                                      type: TextDandyLight.LARGE_TEXT,
                                      text: 'DOWNLOAD',
                                      isBold: true,
                                      fontFamily: FontTheme.MontserratAlternativesRegular,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: buildMenuItems(),
              leadingWidth: 182,
              leading: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 14, left: 32),
                    width: 182,
                    child: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontSize: 32,
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
                    margin: EdgeInsets.only(left: 107.0, top: 4.0),
                    height: 300.0,
                    child: Image.asset(ImageUtil.LOGIN_BG_LOGO_FLOWER, height: 300,),
                  ),
                ],
              ),
            );
          },
        ),
        //3
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return infoWidgets[index];
            },
            childCount: infoWidgets.length
          ),
        ),
      ],
    ),
  );

  List<Widget> buildMenuItems() {
    return [
      isCollapsed ? MouseRegion(
        child: Container(
          margin: EdgeInsets.only(left: 32, right: 32, top: 0),
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            fontFamily: FontTheme.MontserratAlternativesRegular,
            text: 'Download\nApple',
            textAlign: TextAlign.center,
            color: isHoveredApple ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
          ),
        ),
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHoveredApple = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHoveredApple = false;
          });
        },
      ) : SizedBox(),
      isCollapsed ? MouseRegion(
        child: Container(
          margin: EdgeInsets.only(left: 32, right: 32, top: 0),
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            fontFamily: FontTheme.MontserratAlternativesRegular,
            textAlign: TextAlign.center,
            text: 'Download\nAndroid',
            color: isHoveredAndroid ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
          ),
        ),
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHoveredAndroid = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHoveredAndroid = false;
          });
        },
      ) : SizedBox(),
      MouseRegion(
        child: Container(
          margin: EdgeInsets.only(left: 32, right: 32, top: 0),
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            fontFamily: FontTheme.OPEN_SANS,
            text: 'About us',
            color: isHoveredAbout ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
          ),
        ),
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHoveredAbout = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHoveredAbout = false;
          });
        },
      ),
      MouseRegion(
        child: Container(
          margin: EdgeInsets.only(left: 32, right: 32, top: 0),
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            fontFamily: FontTheme.OPEN_SANS,
            text: 'Pricing',
            color: isHoveredPricing ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
          ),
        ),
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHoveredPricing = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHoveredPricing = false;
          });
        },
      ),
      MouseRegion(
        child: Container(
          margin: EdgeInsets.only(left: 32, right: 64, top: 0),
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            fontFamily: FontTheme.OPEN_SANS,
            text: 'Blog',
            color: isHoveredBlog ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
          ),
        ),
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHoveredBlog = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHoveredBlog = false;
          });
        },
      )
    ];
  }

  List<Widget> buildInfoWidgets() {
    return [
      Container(
        height: 800,
        margin: EdgeInsets.only(bottom: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("images/landing_page/web_mobile_branding.png", height: 800,),
            ),
            SizedBox(width: 64),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 450,
                  margin: EdgeInsets.only(bottom: 32),
                  child: AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: FontTheme.OPEN_SANS,
                      fontWeight: FontWeight.bold,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: Text(
                      'Professional client portal custom to your brand!',
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  width: 450,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(text: "Wow your clients with a beautiful branded client portal. A central hub to share the ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "contract", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " , invoice, poses and job details.", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        height: 800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 450,
                  margin: EdgeInsets.only(bottom: 32),
                  child: AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: FontTheme.OPEN_SANS,
                      fontWeight: FontWeight.bold,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: Text(
                      'Professional client portal custom to your brand!',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                Container(
                  width: 450,
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(text: "Wow your clients with a beautiful branded client portal. A central hub to share the ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "contract", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " , invoice, poses and job details.", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                        ]
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 64),
            Container(
              child: Image.asset("images/landing_page/branding.png", height: 600,),
            ),
          ],
        ),
      ),
      Container(
        height: 800,
        margin: EdgeInsets.only(bottom: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("images/landing_page/job_details.png", height: 600,),
            ),
            SizedBox(width: 64),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 450,
                  margin: EdgeInsets.only(bottom: 32),
                  child: AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: FontTheme.OPEN_SANS,
                      fontWeight: FontWeight.bold,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: Text(
                      'Professional client portal custom to your brand!',
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  width: 450,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(text: "Wow your clients with a beautiful branded client portal. A central hub to share the ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "contract", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " , invoice, poses and job details.", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        height: 800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 450,
                  margin: EdgeInsets.only(bottom: 32),
                  child: AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: FontTheme.OPEN_SANS,
                      fontWeight: FontWeight.bold,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: Text(
                      'Professional client portal custom to your brand!',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                Container(
                  width: 450,
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(text: "Wow your clients with a beautiful branded client portal. A central hub to share the ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "contract", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " , invoice, poses and job details.", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                        ]
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 64),
            Container(
              child: Image.asset("images/landing_page/sunset_weather.png", height: 600,),
            ),
          ],
        ),
      ),
      Container(
        height: 800,
        margin: EdgeInsets.only(bottom: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("images/landing_page/expenses.png", height: 600,),
            ),
            SizedBox(width: 64),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 450,
                  margin: EdgeInsets.only(bottom: 32),
                  child: AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: FontTheme.OPEN_SANS,
                      fontWeight: FontWeight.bold,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: Text(
                      'Professional client portal custom to your brand!',
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  width: 450,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(text: "Wow your clients with a beautiful branded client portal. A central hub to share the ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "contract", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " , invoice, poses and job details.", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

}
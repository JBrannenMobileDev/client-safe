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
  bool isCollapsed = false;

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
              expandedHeight: 750.0,
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
                    )
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
                (_, int index) {
              return ListTile(
                leading: Container(
                    padding: EdgeInsets.all(8),
                    width: 100,
                    child: Placeholder()),
                title: Text('Place ${index + 1}', textScaleFactor: 2),
              );
            },
            childCount: 40,
          ),
        ),
      ],
    ),
  );

  List<Widget> buildMenuItems() {
    return [
      MouseRegion(
        child: Container(
          margin: EdgeInsets.only(left: 32, right: 32, top: 0),
          alignment: Alignment.center,
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            fontFamily: FontTheme.MontserratAlternativesRegular,
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
            fontFamily: FontTheme.MontserratAlternativesRegular,
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
            fontFamily: FontTheme.MontserratAlternativesRegular,
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

}
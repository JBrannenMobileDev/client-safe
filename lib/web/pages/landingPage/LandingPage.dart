import 'package:dandylight/models/FontTheme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../navigation/routes/RouteNames.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/DeviceType.dart';
import '../../../utils/ImageUtil.dart';
import '../../../utils/Shadows.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../utils/intentLauncher/IntentLauncherUtil.dart';
import '../../../widgets/TextDandyLight.dart';
import 'PricingInfo.dart';
import 'package:universal_html/html.dart' as html;

import 'blogPage/BlogPage.dart';

class LandingPage extends StatefulWidget{
  final String comingFrom;
  LandingPage({this.comingFrom});


  @override
  State<StatefulWidget> createState() {
    return _LandingPageState(comingFrom);
  }
}

class _LandingPageState extends State<LandingPage> {
  static const String PRICING = 'pricing';
  static const String HOME = 'home';
  static const String BLOG = 'blog';
  static const String ABOUT = 'about';
  final String comingFrom;

  _LandingPageState(this.comingFrom);

  ScrollController _scrollController = ScrollController();
  String selectedPage = HOME;
  bool isHoveredPricing = false;
  bool isHoveredBlog = false;
  bool isHoveredAbout = false;
  bool isHoveredApple = false;
  bool isHoveredAndroid = false;
  bool isIphone = false;
  bool isAndroidPhone = false;



  void handleClick(String value) {
    switch (value) {
      case 'About us':
        // NavigationUtil.onEditBrandingSelected(context);
        // EventSender().sendEvent(eventName: EventNames.BRANDING_EDIT_FROM_SHARE);
        break;
      case 'Pricing':
        setState(() {
          selectedPage = PRICING;
        });
        EventSender().sendEvent(eventName: EventNames.NAV_TO_PRICING_PAGE);
        break;
      case 'Blog':
        setState(() {
          selectedPage = BLOG;
        });
        EventSender().sendEvent(eventName: EventNames.NAV_TO_BLOG_PAGE);
        break;
    }
  }

  Widget getSliverList(String selectedPage) {
    switch(selectedPage) {
      case HOME:
        return SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return buildInfoWidgetsWeb()[index];
          },
              childCount: buildInfoWidgetsWeb().length
          ),
        );
      case ABOUT:
        return SizedBox();
      case PRICING:
        return SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            List<Widget> pricingPage = [PricingInfo()];
            return pricingPage[index];
          },
              childCount: 1
          ),
        );
      case BLOG:
        return SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            List<Widget> blogPage = [BlogPage()];
            return blogPage[index];
          },
              childCount: 1
          ),
        );
    }
    return SizedBox();
  }


  @override
  void initState() {
    super.initState();
    checkDeviceInfo();
  }

  @override
  Widget build(BuildContext context) =>  WillPopScope(
      onWillPop: () async {
        setState(() {
          selectedPage = HOME;
        });
        return false;
      },
      child: Scaffold(
    backgroundColor: Color(selectedPage == PRICING ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryWhite()),
    //1
    body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverLayoutBuilder(
              builder: (BuildContext context, constraints) {
                return SliverAppBar(
                  toolbarHeight: 84,
                  backgroundColor: Color(ColorConstants.getBlueDark()),
                  expandedHeight: selectedPage != HOME ? 0 : DeviceType.getDeviceTypeByContext(context) == Type.Website ? 550.0 : 232,
                  pinned: true,
                  flexibleSpace: selectedPage != HOME ? SizedBox() : DeviceType.getDeviceTypeByContext(context) == Type.Website ? FlexibleSpaceBar(
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
                                    EventSender().sendEvent(eventName: EventNames.WEBSITE_DOWNLOAD_CLICKED, properties: {
                                      EventNames.WEBSITE_DOWNLOAD_CLICKED_PARAM : comingFrom
                                    });
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
                                    EventSender().sendEvent(eventName: EventNames.WEBSITE_DOWNLOAD_CLICKED, properties: {
                                      EventNames.WEBSITE_DOWNLOAD_CLICKED_PARAM : comingFrom
                                    });
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
                  ) : FlexibleSpaceBar(
                    background: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 32, right: 32, left: 32),
                              child: Text(
                                'All-in-one solution to\nWOW your clients with professionalism',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: FontTheme.MONTSERRAT,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: DeviceType.getDeviceTypeByContext(context) == Type.Website ? buildMenuItems() : <Widget>[
                    PopupMenuButton<String>(
                      icon: Icon(Icons.menu_rounded, color: Color(ColorConstants.getPrimaryWhite())),
                      iconSize: 32,
                      onSelected: handleClick,
                      padding: EdgeInsets.only(right: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      itemBuilder: (BuildContext context) {
                        return {'About us', 'Pricing', 'Blog'}.map((String choice) {
                          Widget icon = SizedBox();
                          switch (choice) {
                            case 'About us':
                              icon = Image.asset('icons/aboutUs.png');
                              break;
                            case 'Pricing':
                              icon = Image.asset('icons/pricing.png');
                              break;
                            case 'Blog':
                              icon = Image.asset('icons/blog.png');
                              break;
                          }
                          icon = Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 18.0, left: 2.0),
                            height: 28.0,
                            width: 28.0,
                            child: icon,
                          );
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Row(
                              children: [
                                icon,
                                TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: choice,
                                )
                              ],
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ],
                  leadingWidth: 182,
                  leading: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 34, left: 39),
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
                          child: TextDandyLight(
                            type: TextDandyLight.EXTRA_LARGE_TEXT,
                            text: 'DandyLight',
                            fontFamily: 'simple',
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 108.5, top: 8.0),
                        height: 300.0,
                        child: Image.asset(ImageUtil.LOGIN_BG_LOGO_FLOWER, height: 300,),
                      ),
                    ],
                  ),
                );
              },
            ),
            //3
            getSliverList(selectedPage),
          ],
        ),
        DeviceType.getDeviceTypeByContext(context) != Type.Website ? Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isIphone ? GestureDetector(
              onTap: () {
                final url = Uri.parse("https://apps.apple.com/app/id6444910643",);
                launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
                EventSender().sendEvent(eventName: EventNames.WEBSITE_DOWNLOAD_CLICKED, properties: {
                  EventNames.WEBSITE_DOWNLOAD_CLICKED_PARAM : comingFrom
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 32, right: 32, bottom: 16),
                height: 64,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(48),
                    color: Color(ColorConstants.getPeachDark()),
                    boxShadow: ElevationToShadow[6]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 4),
                      height: 32.0,
                      child: Image.asset(ImageUtil.WEBSITE_APPLE_STORE),
                    ),
                    TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Start free trial',
                      isBold: true,
                      fontFamily: FontTheme.MontserratAlternativesRegular,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    )
                  ],
                ),
              ),
            ) : SizedBox(),
            SizedBox(height: 8),
            isAndroidPhone ? GestureDetector(
              onTap: () {
                final url = Uri.parse("https://play.google.com/store/apps/details?id=com.dandylight.mobile");
                launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
                EventSender().sendEvent(eventName: EventNames.WEBSITE_DOWNLOAD_CLICKED, properties: {
                  EventNames.WEBSITE_DOWNLOAD_CLICKED_PARAM : comingFrom
                });
              },
              child: Container(
                height: 64,
                width: 300,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(48),
                    color: Color(ColorConstants.getPrimaryBlack()),
                    boxShadow: ElevationToShadow[6]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0.0, top: 0.0),
                      height: 32.0,
                      child: Image.asset(ImageUtil.WEBSITE_GOOGLE_PLAY),
                    ),
                    TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Start free trial',
                      isBold: true,
                      fontFamily: FontTheme.MontserratAlternativesRegular,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    )
                  ],
                ),
              ),
            ) : SizedBox()
          ],
        ) : SizedBox(),
      ],
    ),
      ),
  );

  List<Widget> buildMenuItems() {
    return [
      MouseRegion(
        child: GestureDetector(
          onTap: () {
            final url = Uri.parse("https://apps.apple.com/app/id6444910643",);
            launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
            EventSender().sendEvent(eventName: EventNames.WEBSITE_DOWNLOAD_CLICKED, properties: {
              EventNames.WEBSITE_DOWNLOAD_CLICKED_PARAM : comingFrom
            });
          },
          child: Container(
            height: 48,
            margin: EdgeInsets.only(left: 32, right: 0, top: 16, bottom: 16),
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHoveredApple ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
                width: 2, //width of border
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0.0, top: 0.0),
                  height: 24.0,
                  child: Image.asset(ImageUtil.WEBSITE_APPLE_STORE),
                ),
                SizedBox(
                  width: 8,
                ),
                TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  fontFamily: FontTheme.MontserratAlternativesRegular,
                  textAlign: TextAlign.center,
                  text: 'Download',
                  color: isHoveredApple ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
                )
              ],
            ),
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
      ),
      MouseRegion(
        child: GestureDetector(
          onTap: () {
            final url = Uri.parse("https://play.google.com/store/apps/details?id=com.dandylight.mobile");
            launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
            EventSender().sendEvent(eventName: EventNames.WEBSITE_DOWNLOAD_CLICKED, properties: {
              EventNames.WEBSITE_DOWNLOAD_CLICKED_PARAM : comingFrom
            });
          },
          child: Container(
            height: 48,
            margin: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHoveredAndroid ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
                width: 2, //width of border
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0.0, top: 0.0),
                  height: 24.0,
                  child: Image.asset(ImageUtil.WEBSITE_GOOGLE_PLAY),
                ),
                SizedBox(
                  width: 8,
                ),
                TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  fontFamily: FontTheme.MontserratAlternativesRegular,
                  textAlign: TextAlign.center,
                  text: 'Download',
                  color: isHoveredAndroid ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
                )
              ],
            ),
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
      ),
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
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = PRICING;
            _scrollController.jumpTo(0);
          });
        },
        child: MouseRegion(
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
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedPage = BLOG;
            _scrollController.jumpTo(0);
          });
        },
        child: MouseRegion(
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
        ),
      ),
    ];
  }

  List<Widget> buildProductInfoListWeb() {
    return [
      comingFrom == RouteNames.POSE_INFO ? Container(
        height: 800,
        margin: EdgeInsets.only(bottom: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("images/landing_page/poses_1.png", height: 800,),
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
                      'Get inspiration from our pose library',
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 32),
                  width: 450,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(text: "Browse and select poses to add a unique touch to your photography sessions and ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "enhance", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " the visual appeal of your work.", style: TextStyle(
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
      ) : SizedBox(),
      comingFrom == RouteNames.POSE_INFO ? Container(
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
                      'Get featured!',
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
                          TextSpan(text: "Submit your most captivating shots to be ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "featured", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " in our exclusive Pose Library. Showcase your unique style, creativity, and expertise to our global community.", style: TextStyle(
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
              child: Image.asset("images/landing_page/poses_2.png", height: 600,),
            ),
          ],
        ),
      ) : SizedBox(),
      comingFrom == RouteNames.POSE_INFO ? Container(
        height: 800,
        margin: EdgeInsets.only(bottom: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("images/landing_page/poses_3.png", height: 800,),
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
                      'Photo credit is always given to the photographer',
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 32),
                  width: 450,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(text: "At Dandylight, we deeply value the creative contributions of photographers, and we believe in ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "giving credit where it's due.", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "\n\nThat's why we make it a priority to showcase the incredible talent behind each photograph by linking directly to the photographer's Instagram account. This not only recognizes their skill and effort but also allows users to explore more of their work and connect with them on a platform they love.", style: TextStyle(
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
      ) : SizedBox(),
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
                      'Professional client portal custom to your brand',
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 32),
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
                GestureDetector(
                  onTap: () {
                    _launchBrandingPreviewURL('OVsjf1eEYDSjEKd9sHkyLyqccXO2');
                    EventSender().sendEvent(eventName: EventNames.WEBSITE_PREVIEW_CLIENT_PORTAL_CLICKED);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    width: 450,
                    alignment: Alignment.center,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        color: Color(ColorConstants.getPrimaryWhite()),
                        fontFamily: FontTheme.OPEN_SANS,
                        text: "Preview Client Portal"
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
                      'Setup your brand with ease',
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
                          TextSpan(text: "Choose your own color and font theme. Upload your logo and ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "showcase", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " your creativity with a banner image.", style: TextStyle(
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
                      'Save time by tracking your jobs in one place',
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
                          TextSpan(text: "Have all of your job details in one place, keeping you organized and ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "saving you time!", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
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
                      'Sunset & Weather',
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
                          TextSpan(text: "Never miss golden hour again! Our sunset and weather can prepare you for any photoshoot no matter how far in advance. ", style: TextStyle(
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
                      'Take the stress out of tax season',
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
                          TextSpan(text: "Effortlessly manage your finances and track your miles driven. Use our ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "mileage calculator", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " and expense tracker to simplifying tax preparation and maximize your ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "deductions", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " and profitability.", style: TextStyle(
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
                      'Get inspiration from our pose library',
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
                          TextSpan(text: "Browse and select poses to add a unique touch to your photography sessions and ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "enhance", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " the visual appeal of your work.", style: TextStyle(
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
              child: Image.asset("images/landing_page/poses.png", height: 600,),
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
              child: Image.asset("images/landing_page/business_analytics.png", height: 600,),
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
                      'Grow your business with analytics',
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
                          TextSpan(text: "See where your most ", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "profitable leads", style: TextStyle(
                            fontSize: 26,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " are coming from so you can double down on your marketing efforts.", style: TextStyle(
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

  List<Widget> buildProductInfoListMobile() {
    return [
      comingFrom == RouteNames.POSE_INFO ? Container(
        margin: EdgeInsets.only(bottom: 128, top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Get inspiration from our pose library',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/poses_1.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "Browse and select poses to add a unique touch to your photography sessions and ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "enhance", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " the visual appeal of your work.", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
              ),
            ),
          ],
        ),
      ): SizedBox(),
      comingFrom == RouteNames.POSE_INFO ? Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Get featured!',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/poses_2.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "Submit your most captivating shots to be ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "featured", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " in our exclusive Pose Library. Showcase your unique style, creativity, and expertise to our global community.", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
              ),
            ),
          ],
        ),
      ) : SizedBox(),
      comingFrom == RouteNames.POSE_INFO ? Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Photo credit is always given to the photographer!',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/poses_3.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "At Dandylight, we deeply value the creative contributions of photographers, and we believe in ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "giving credit where it's due.", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "\n\nThat's why we make it a priority to showcase the incredible talent behind each photograph by linking directly to the photographer's Instagram account. This not only recognizes their skill and effort but also allows users to explore more of their work and connect with them on a platform they love.", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
              ),
            ),
          ],
        ),
      ): SizedBox(),
      Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 64, left: 32, right: 32),
                  child: AnimatedDefaultTextStyle(
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: FontTheme.OPEN_SANS,
                      fontWeight: FontWeight.bold,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    child: Text(
                      'Professional client portal custom to your brand',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  child: Image.asset("images/landing_page/web_mobile_branding.png", height: 400,),
                ),
                GestureDetector(
                  onTap: () {
                    _launchBrandingPreviewURL('OVsjf1eEYDSjEKd9sHkyLyqccXO2');
                    EventSender().sendEvent(eventName: EventNames.WEBSITE_PREVIEW_CLIENT_PORTAL_CLICKED);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    width: 196,
                    alignment: Alignment.center,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        color: Color(ColorConstants.getPrimaryWhite()),
                        fontFamily: FontTheme.OPEN_SANS,
                        text: "Preview Client Portal"
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 32, right: 32),
                  width: MediaQuery.of(context).size.width,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(text: "Wow your clients with a beautiful branded client portal. A central hub to share the ", style: TextStyle(
                            fontSize: 24,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: "contract", style: TextStyle(
                            fontSize: 24,
                            fontFamily: FontTheme.OPEN_SANS,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                          TextSpan(text: " , invoice, poses and job details.", style: TextStyle(
                            fontSize: 24,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          )),
                        ]
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 32, right: 32),
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Setup your brand with ease',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/branding.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "Choose your own color and font theme. Upload your logo and ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "showcase", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " your creativity with a banner image.", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Save time by tracking your jobs in one place',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/job_details.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "Have all of your job details in one place, keeping you organized and ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "saving you time!", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Sunset & Weather',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/sunset_weather.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "Never miss golden hour again! Our sunset and weather can prepare you for any photoshoot no matter how far in advance. ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Take the stress out of tax season',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/expenses.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "Effortlessly manage your finances and track your miles driven. Use our ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "mileage calculator", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " and expense tracker to simplifying tax preparation and maximize your ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "deductions", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " and profitability.", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Get inspiration from our pose library',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/poses.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "Browse and select poses to add a unique touch to your photography sessions and ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "enhance", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " the visual appeal of your work.", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: FontTheme.OPEN_SANS,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Text(
                  'Grow your business with analytics',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Image.asset("images/landing_page/business_analytics.png", height: 600,),
            ),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(text: "See where your most ", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: "profitable leads", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                      TextSpan(text: " are coming from so you can double down on your marketing efforts.", style: TextStyle(
                        fontSize: 24,
                        fontFamily: FontTheme.OPEN_SANS,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      )),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> buildInfoWidgetsWeb() {
    List<Widget> result = DeviceType.getDeviceTypeByContext(context) == Type.Website ? buildProductInfoListWeb() : buildProductInfoListMobile();
    result.addAll([
      Container(
        height: 250,
        color: Color(ColorConstants.getBlueDark()),
        child: DeviceType.getDeviceTypeByContext(context) == Type.Website ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                child: GestureDetector(
                  onTap: () {
                    IntentLauncherUtil.launchURL('https://www.instagram.com/dandy.light/');
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 32),
                    height: 54,
                    width: 54,
                    child: Image.asset(
                      "icons/instagram.png",
                    ),
                  ),
                ),
              ),
              MouseRegion(
                child: GestureDetector(
                  onTap: () {
                    IntentLauncherUtil.launchURL('https://www.tiktok.com/@dandylightapp');
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 32),
                    height: 54,
                    width: 54,
                    child: Image.asset(
                      "icons/tiktok.png",
                    ),
                  ),
                ),
              ),
              MouseRegion(
                child: GestureDetector(
                  onTap: () {
                    IntentLauncherUtil.launchURL('https://www.youtube.com/@DandyLight-APP');
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 32),
                    height: 54,
                    width: 54,
                    child: Image.asset(
                      "icons/youtube.png",
                    ),
                  ),
                ),
              ),
              MouseRegion(
                child: GestureDetector(
                  onTap: () {
                    IntentLauncherUtil.launchURL('https://www.pinterest.com/DandyLightApp/');
                  },
                  child: Container(
                    height: 54,
                    width: 54,
                    child: Image.asset(
                      "icons/pinterest.png",
                    ),
                  ),
                ),
              ),
              DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                margin: EdgeInsets.only(left: 32, right: 0, top: 0),
                alignment: Alignment.center,
                height: 54,
                width: 54,
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: '|',
                  isBold: true,
                  fontFamily: FontTheme.MontserratAlternativesRegular,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ) : SizedBox(),
              MouseRegion(
                child: GestureDetector(
                  onTap: () {
                    IntentLauncherUtil.sendEmail('support@dandylight.com', 'Contact us', '');
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 32, right: 32, top: 0),
                    alignment: Alignment.center,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      fontFamily: FontTheme.OPEN_SANS,
                      text: 'Contact us',
                      color: isHoveredPricing ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
                    ),
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
              )
            ]
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MouseRegion(
                  child: GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchURL('https://www.instagram.com/dandy.light/');
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 32),
                      height: 54,
                      width: 54,
                      child: Image.asset(
                        "icons/instagram.png",
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  child: GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchURL('https://www.tiktok.com/@dandylightapp');
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 32),
                      height: 54,
                      width: 54,
                      child: Image.asset(
                        "icons/tiktok.png",
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  child: GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchURL('https://www.youtube.com/@DandyLight-APP');
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 32),
                      height: 54,
                      width: 54,
                      child: Image.asset(
                        "icons/youtube.png",
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  child: GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchURL('https://www.pinterest.com/DandyLightApp/');
                    },
                    child: Container(
                      height: 54,
                      width: 54,
                      child: Image.asset(
                        "icons/pinterest.png",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MouseRegion(
              child: GestureDetector(
                onTap: () {
                  IntentLauncherUtil.sendEmail('support@dandylight.com', 'Contact us', '');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 32, right: 32, top: 0),
                  alignment: Alignment.center,
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    fontFamily: FontTheme.OPEN_SANS,
                    text: 'Contact us',
                    color: isHoveredPricing ? Color(ColorConstants.getBlueLight()) : Color(ColorConstants.getPrimaryWhite()),
                  ),
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
            )
          ],
        ),
      ),
      Container(
        height: 164,
        color: Color(ColorConstants.getBlueDark()),
      )
    ]);
    return result;
  }

  void _launchBrandingPreviewURL(String uid) async {
    print('https://dandylight.com/' + RouteNames.BRANDING_PREVIEW + '/' + uid);
    await canLaunchUrl(Uri.parse('https://dandylight.com/' + RouteNames.BRANDING_PREVIEW + '/' + uid)) ? await launchUrl(Uri.parse('https://dandylight.com/' + RouteNames.BRANDING_PREVIEW + '/' + uid), mode: LaunchMode.externalApplication) : throw 'Could not launch';
  }

  void checkDeviceInfo() async {
    final userAgent = html.window.navigator.userAgent.toString().toLowerCase();
    setState(() {
      if(userAgent.contains("iphone") || userAgent.contains("ipad")){
        isIphone = true;
      }
      if(userAgent.contains("android")){
        isAndroidPhone = true;
      }
    });
  }
}


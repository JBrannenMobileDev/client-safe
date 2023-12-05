import 'package:dandylight/widgets/DandyLightNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seo_renderer/renderers/image_renderer/image_renderer_web.dart';
import 'package:seo_renderer/renderers/text_renderer/text_renderer_style.dart';
import 'package:seo_renderer/renderers/text_renderer/text_renderer_web.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/FontTheme.dart';
import '../../../../utils/ColorConstants.dart';
import '../../../../utils/DeviceType.dart';
import '../../../../utils/ImageUtil.dart';
import '../../../../utils/analytics/EventNames.dart';
import '../../../../utils/analytics/EventSender.dart';
import '../../../../widgets/TextDandyLight.dart';

class BlogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlogPageState();
  }
}

class _BlogPageState extends State<BlogPage> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 264),
          color: Color(ColorConstants.getBlueDark()),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 32, bottom: 32, right: 32, left: 32),
                child: Text(
                  'Blog Article Categories',
                  style: TextStyle(
                      fontSize: 36,
                      fontFamily: FontTheme.MONTSERRAT,
                      color: Color(ColorConstants.getPrimaryWhite()),
                      fontWeight: FontWeight.w600
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              DeviceType.getDeviceTypeByContext(context) == Type.Website ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  blogCategories(),
                  SizedBox(width: 64),
                  tryNowContainer(),
                ],
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tryNowContainer(),
                  SizedBox(width: 64),
                  blogCategories(),
                ],
              )
            ],
          ),
        ),
        backArrow(),
      ],
    );
  }

  Widget blogCategories() {
    return Container(
      alignment: Alignment.topCenter,
      height: 1080,
      width: 920,
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(ColorConstants.getPrimaryWhite())
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 436,
                padding: EdgeInsets.only(top: 32, left: 24, bottom: 16),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "Alternatives", style: TextStyle(
                          fontSize: 26,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                      ]
                  ),
                ),
              ),
              AlternativesItem1(),
              SizedBox(height: 24),
              AlternativesItem2(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 436,
                padding: EdgeInsets.only(top: 32, left: 24, bottom: 16),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "Features", style: TextStyle(
                          fontSize: 26,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                      ]
                  ),
                ),
              ),
              FeaturesItem1(),
              SizedBox(height: 24),
              FeaturesItem2(),
            ],
          ),
        ],
      )
    );
  }

  Widget tryNowContainer() {
    return Container(
      alignment: Alignment.topCenter,
      width: 440,
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(ColorConstants.getPrimaryWhite())
      ),
      child: Column(
        children: [
          SizedBox(height: 32),
          RichText(
            text: TextSpan(
                style: TextStyle(fontWeight: FontWeight.normal),
                children: [
                  TextSpan(text: "Photography Business App", style: TextStyle(
                    fontSize: 26,
                    fontFamily: FontTheme.OPEN_SANS,
                    fontWeight: FontWeight.bold,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  )),
                ]
            ),
          ),
          SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16, left: 16),
                child: Image.asset("icons/save_time.png", height: 48),
              ),
              Container(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "SAVE TIME", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                        TextSpan(text: " with Job tracking.", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                      ]
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16, left: 18),
                child: Image.asset("icons/save_money.png", height: 44),
              ),
              Container(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "SAVE MONEY", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                        TextSpan(text: " with our", style: TextStyle(
                            fontSize: 16,
                            fontFamily: FontTheme.OPEN_SANS,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        TextSpan(text: " mileage tracker.", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                      ]
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16, left: 18),
                child: Image.asset("icons/grow_your_biz.png", height: 44),
              ),
              Container(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "GROW YOUR BUSINESS", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                        TextSpan(text: " by running\nit like a professional.", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                      ]
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16, left: 18),
                child: Image.asset("icons/get_inspired.png", height: 44),
              ),
              Container(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "GET INSPIRED", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                        TextSpan(text: " with our ", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                        TextSpan(text: "pose library.", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                      ]
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16, left: 18),
                child: Image.asset("icons/web_client_portal.png", height: 44),
              ),
              Container(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "WOW CLIENTS", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                        TextSpan(text: " with our branded ", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                        TextSpan(text: "\nclient portal.", style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontTheme.OPEN_SANS,
                          fontWeight: FontWeight.bold,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        )),
                      ]
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 64),
          Column(
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
                    EventNames.WEBSITE_DOWNLOAD_CLICKED_PARAM : 'Blog page'
                  });
                },
                child: Container(
                  height: 64,
                  width: 264,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      color: Color(ColorConstants.getPeachDark())
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 4),
                        height: 32.0,
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
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  final url = Uri.parse("https://play.google.com/store/apps/details?id=com.dandylight.mobile");
                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                  EventSender().sendEvent(eventName: EventNames.WEBSITE_DOWNLOAD_CLICKED, properties: {
                    EventNames.WEBSITE_DOWNLOAD_CLICKED_PARAM : "Blog page"
                  });
                },
                child: Container(
                  height: 64,
                  width: 264,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      color: Color(ColorConstants.getPeachDark())
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0.0, top: 0.0),
                        height: 32.0,
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
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget backArrow() {
    return Container(
      margin: EdgeInsets.only(top: 22, right: 1232),
      child: GestureDetector(
        onTap: () {

        },
        child: Container(
          height: 64,
          width: 264,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 0.0, top: 0.0, right: 8),
                height: 48.0,
                child: Icon(Icons.arrow_back, color: Color(ColorConstants.getPrimaryWhite())),
              ),
              TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Alternatives',
                fontFamily: FontTheme.MontserratAlternativesRegular,
                color: Color(ColorConstants.getPrimaryWhite()),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget AlternativesItem1() {
    return Container(
      width: 436,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.only(left: 32),
            child: ImageRenderer(
                alt: 'Network Image',
                child: DandyLightNetworkImage('https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2Fblog_images%2Fheader_image_13.png?alt=media&token=a7721da1-78fd-4b08-b722-823fd4fa65fb')
            ),
          ),
          SizedBox(width: 8),
          TextRenderer(
            text: 'Alternatives to Honeybook (5 options)',
            style: TextRendererStyle.header3,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Alternatives to Honeybook (5 options)',
              isBold: true,
              fontFamily: FontTheme.MontserratAlternativesRegular,
              color: Color(ColorConstants.getPrimaryBlack()).withOpacity(.5),
            ),
          )
        ],
      ),
    );
  }

  Widget AlternativesItem2() {
    return Container(
      width: 436,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.only(left: 32),
            child: ImageRenderer(
                alt: 'Network Image',
                child: DandyLightNetworkImage('https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2Fblog_images%2Fheader_image_5.jpg?alt=media&token=5417d7db-20c5-4da1-8889-e44cf8b8014c')
            ),
          ),
          SizedBox(width: 8),
          TextRenderer(
            text: 'Alternatives to Unscripted (5 options)',
            style: TextRendererStyle.header3,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Alternatives to Unscripted (5 options)',
              isBold: true,
              fontFamily: FontTheme.MontserratAlternativesRegular,
              color: Color(ColorConstants.getPrimaryBlack()).withOpacity(.5),
            ),
          )
        ],
      ),
    );
  }

  Widget FeaturesItem1() {
    return Container(
      width: 436,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.only(left: 32),
            child: ImageRenderer(
                alt: 'Network Image',
                child: DandyLightNetworkImage('https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2Fblog_images%2Fheader_image_12.png?alt=media&token=697c275d-c440-435c-b411-f1fb09d69d05')
            ),
          ),
          SizedBox(width: 8),
          TextRenderer(
            text: '4 Reasons a photographer needs a branded client portal',
            style: TextRendererStyle.header3,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '4 Reasons a photographer needs a \nbranded client portal',
              isBold: true,
              fontFamily: FontTheme.MontserratAlternativesRegular,
              color: Color(ColorConstants.getPrimaryBlack()).withOpacity(.5),
            ),
          )
        ],
      ),
    );
  }

  Widget FeaturesItem2() {
    return Container(
      width: 436,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.only(left: 32),
            child: ImageRenderer(
                alt: 'Network Image',
                child: DandyLightNetworkImage('https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2Fblog_images%2Fheader_image_3.png?alt=media&token=520aa0cf-1ce5-4608-b96d-056bde93ff60')
            ),
          ),
          SizedBox(width: 8),
          TextRenderer(
            text: '6 Best photography contract e-signing tools',
            style: TextRendererStyle.header3,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '6 Best photography contract \ne-signing tools',
              isBold: true,
              fontFamily: FontTheme.MontserratAlternativesRegular,
              color: Color(ColorConstants.getPrimaryBlack()).withOpacity(.5),
            ),
          )
        ],
      ),
    );
  }
}
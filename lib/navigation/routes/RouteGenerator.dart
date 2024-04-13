import 'package:dandylight/navigation/routes/RouteNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../web/pages/DeleteAccountInfoPage.dart';
import '../../web/pages/ProposalPage/ProposalPage.dart';
import '../../web/pages/landingPage/LandingPage.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var uri = Uri.parse(settings.name!);

    /**
     * Client Portal
     */
    if(uri.pathSegments.length == 2 && uri.pathSegments.first == RouteNames.CLIENT_PORTAL) {
      var id = uri.pathSegments[1];
      var params = id.split('+');
      EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_VIEWED);
      return _GeneratePageRoute(
          widget: ProposalPage(userId: params[0], jobId: params[1], isBrandingPreview: false),
          routeName: settings.name!
      );
    }

    /**
     * Branding Preview
     */
    if(uri.pathSegments.length == 2 && uri.pathSegments.first == RouteNames.BRANDING_PREVIEW) {
      var uid = uri.pathSegments[1];
      EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_PREVIEW_VIEWED);
      return _GeneratePageRoute(
          widget: ProposalPage(userId: uid, jobId: null, isBrandingPreview: true),
          routeName: settings.name!
      );
    }

    /**
     * PoseInfo
     */
    if(uri.pathSegments.length == 1 && uri.pathSegments.first == RouteNames.POSE_INFO) {
      EventSender().sendEvent(eventName: EventNames.WEBSITE_VIEWED, properties: {
        EventNames.WEBSITE_VIEWED_PARAM : RouteNames.POSE_INFO,
      });
      return _GeneratePageRoute(
          widget: LandingPage(comingFrom: RouteNames.POSE_INFO),
          routeName: settings.name!
      );
    }

    /**
     * Delete Account Info
     */
    if(uri.pathSegments.length == 1 && uri.pathSegments.first == RouteNames.DELETE_ACCOUNT_INFO) {
      EventSender().sendEvent(eventName: EventNames.WEBSITE_VIEWED, properties: {
        EventNames.WEBSITE_VIEWED_PARAM : uri.pathSegments.first,
      });
      return _GeneratePageRoute(
          widget: DeleteAccountInfoPage(),
          routeName: settings.name!
      );
    }

    /**
     * Landing page
     */
    if(uri.pathSegments.length == 1 && uri.pathSegments.first != RouteNames.POSE_INFO) {
      EventSender().sendEvent(eventName: EventNames.WEBSITE_VIEWED, properties: {
        EventNames.WEBSITE_VIEWED_PARAM : uri.pathSegments.first,
      });
      return _GeneratePageRoute(
          widget: LandingPage(comingFrom: uri.pathSegments.first),
          routeName: settings.name!
      );
    }

    EventSender().sendEvent(eventName: EventNames.WEBSITE_VIEWED);
    return _GeneratePageRoute(
        widget: LandingPage(comingFrom: 'organicSearch'),
        routeName: settings.name!
    );
  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget? widget;
  final String? routeName;
  _GeneratePageRoute({this.widget, this.routeName})
      : super(
      settings: RouteSettings(name: routeName),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget!;
      },
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        return SlideTransition(
          textDirection: TextDirection.rtl,
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      });
}
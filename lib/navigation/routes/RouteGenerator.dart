import 'package:dandylight/navigation/routes/RouteNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../web/pages/ProposalPage/ProposalPage.dart';
import '../../web/pages/landingPage/LandingPage.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.CLIENT_PORTAL:
        return _GeneratePageRoute(
            widget: ProposalPage(),
            routeName: settings.name
        );
      case RouteNames.ANSWER_QUESTIONNAIRE:
        return _GeneratePageRoute(widget: Container(), routeName: settings.name);
      case RouteNames.LANDING_PAGE:
        return _GeneratePageRoute(
            widget: LandingPage(),
            routeName: settings.name
        );
      default:
        return _GeneratePageRoute(
            widget: Container(), routeName: settings.name);
    }
  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String routeName;
  _GeneratePageRoute({this.widget, this.routeName})
      : super(
      settings: RouteSettings(name: routeName),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
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
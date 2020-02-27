import 'package:client_safe/pages/client_details_page/ClientDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationUtil {
  static onClientTapped(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ClientDetailsPage()));
  }
}
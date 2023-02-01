import 'dart:ui';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';


class InvoiceInfo extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _InvoiceInfo();
  }
}

class _InvoiceInfo extends State<InvoiceInfo> {

  @override
  Widget build(BuildContext context) {
    return Container(
            alignment: Alignment.topCenter,
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Send Invoices',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 88,
                        width: 88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(ColorConstants.getBlueLight()),
                        ),
                      ),
                      Container(
                        width: 56,
                        child: Image.asset('assets/images/icons/invoices_icon_white.png', color: Color(ColorConstants.getPrimaryWhite()),),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Generate invoices and send with Zelle, Venmo, Cash App, or Apple Pay info included.',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),

    );
  }
}

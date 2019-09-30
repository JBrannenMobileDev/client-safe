import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'NewContactTextField.dart';

class PhoneEmailInstagram extends StatefulWidget {
  @override
  _PhoneEmailInstagramState createState() {
    return _PhoneEmailInstagramState();
  }
}

class _PhoneEmailInstagramState extends State<PhoneEmailInstagram> {
  final phoneTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final instagramUrlTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26.0, right: 26.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NewContactTextField(phoneTextController, "Phone", TextInputType.phone),
          NewContactTextField(emailTextController, "Email", TextInputType.emailAddress),
          NewContactTextField(instagramUrlTextController, "Instagram URL", TextInputType.url),
        ],
      ),
    );
  }
}

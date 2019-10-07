import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'NewContactTextField.dart';

class PhoneEmailInstagram extends StatefulWidget {
  final NewContactPageState pageState;

  PhoneEmailInstagram(this.pageState);

  @override
  _PhoneEmailInstagramState createState() {
    return _PhoneEmailInstagramState(pageState);
  }
}

class _PhoneEmailInstagramState extends State<PhoneEmailInstagram> {
  final NewContactPageState pageState;
  final phoneTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final instagramUrlTextController = TextEditingController();

  _PhoneEmailInstagramState(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26.0, right: 26.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NewContactTextField(phoneTextController, "Phone", TextInputType.phone, 65.0, pageState.onPhoneTextChanged),
          NewContactTextField(emailTextController, "Email", TextInputType.emailAddress, 65.0, pageState.onEmailTextChanged),
          NewContactTextField(instagramUrlTextController, "Instagram URL", TextInputType.url, 65.0, pageState.onInstagramUrlChanged),
        ],
      ),
    );
  }
}

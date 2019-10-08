import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'NewContactTextField.dart';

class PhoneEmailInstagram extends StatefulWidget {

  @override
  _PhoneEmailInstagramState createState() {
    return _PhoneEmailInstagramState();
  }
}

class _PhoneEmailInstagramState extends State<PhoneEmailInstagram> with AutomaticKeepAliveClientMixin{
  final phoneTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final instagramUrlTextController = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewContactPageState>(
        converter: (store) => NewContactPageState.fromStore(store),
        builder: (BuildContext context, NewContactPageState pageState) =>
            Container(
          margin: EdgeInsets.only(left: 26.0, right: 26.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NewContactTextField(phoneTextController, "Phone",
                  TextInputType.phone, 60.0, pageState.onPhoneTextChanged),
              NewContactTextField(
                  emailTextController,
                  "Email",
                  TextInputType.emailAddress,
                  60.0,
                  pageState.onEmailTextChanged),
              NewContactTextField(instagramUrlTextController, "Instagram URL",
                  TextInputType.url,  60.0,pageState.onInstagramUrlChanged),
            ],
          ),
        ),
      );

  @override
  bool get wantKeepAlive => true;
}

import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhoneEmailInstagram extends StatefulWidget {
  @override
  _PhoneEmailInstagramState createState() {
    return _PhoneEmailInstagramState();
  }
}

class _PhoneEmailInstagramState extends State<PhoneEmailInstagram> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final instagramUrlTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26.0, right: 26.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 65.0,
            child: TextField(
              controller: firstNameTextController,
              onChanged: (text) {},
              keyboardType: TextInputType.text,
              style: new TextStyle(
                color: const Color(ColorConstants.primary_black),
                fontSize: 18.0,
              ),
              decoration: new InputDecoration(
                filled: false,
                hintText: "First Name",
                hintStyle: new TextStyle(
                  color: const Color(ColorConstants.primary_black),
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 65.0,
            child: TextField(
              controller: lastNameTextController,
              onChanged: (text) {},
              keyboardType: TextInputType.text,
              style: new TextStyle(
                color: const Color(ColorConstants.primary_black),
                fontSize: 18.0,
              ),
              decoration: new InputDecoration(
                filled: false,
                hintText: "last Name",
                hintStyle: new TextStyle(
                  color: const Color(ColorConstants.primary_black),
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 65.0,
            child: TextField(
              controller: instagramUrlTextController,
              onChanged: (text) {},
              keyboardType: TextInputType.text,
              style: new TextStyle(
                color: const Color(ColorConstants.primary_black),
                fontSize: 18.0,
              ),
              decoration: new InputDecoration(
                filled: false,
                hintText: "Instagram URL",
                hintStyle: new TextStyle(
                  color: const Color(ColorConstants.primary_black),
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

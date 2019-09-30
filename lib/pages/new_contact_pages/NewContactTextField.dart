import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewContactTextField extends StatelessWidget{
  final TextEditingController _controller;
  final String hintText;
  final TextInputType inputType;

  NewContactTextField(this._controller, this.hintText, this.inputType);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 65.0,
      child: TextField(
        cursorColor: Color(ColorConstants.primary),
        controller: _controller,
        onChanged: (text) {},
        keyboardType: inputType,
        style: new TextStyle(
          color: const Color(ColorConstants.primary_black),
          fontSize: 18.0,
        ),
        decoration: new InputDecoration(
          filled: false,
          hintText: hintText,
          hintStyle: new TextStyle(
            color: const Color(ColorConstants.primary_black),
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewContactTextField extends StatelessWidget{
  final TextEditingController _controller;
  final String hintText;
  final TextInputType inputType;
  final double height;
  final Function(String) onTextInputChanged;

  NewContactTextField(this._controller, this.hintText, this.inputType, this.height, this.onTextInputChanged);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: height,
      child: TextField(
        maxLines: 8,
        cursorColor: Color(ColorConstants.primary),
        controller: _controller,
        onChanged: (text) {
          onTextInputChanged(text);
        },
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
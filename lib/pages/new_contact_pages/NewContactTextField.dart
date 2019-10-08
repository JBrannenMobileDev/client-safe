import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewContactTextField extends StatelessWidget {
  final TextEditingController _controller;
  final String hintText;
  final TextInputType inputType;
  final double height;
  final Function(String) onTextInputChanged;

  NewContactTextField(this._controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged);

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
      height: height,
      child: new TextFormField(
        maxLines: 24,
        controller: _controller,
        onChanged: (text) {
          onTextInputChanged(text);
        },
        decoration: new InputDecoration(
          alignLabelWithHint: true,
          labelText: hintText,
          hintText: hintText,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          if (val.length == 0) {
            return "First name cannot be empty";
          } else {
            return null;
          }
        },
        keyboardType: inputType,
        style: new TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w600,
        ),
      )

//        TextFormField(
//          maxLines: 8,
//          cursorColor: Color(ColorConstants.primary),
//          controller: _controller,
//          onChanged: (text) {
//            onTextInputChanged(text);
//          },
//          keyboardType: inputType,
//          style: new TextStyle(
//            color: const Color(ColorConstants.primary_black),
//            fontSize: 18.0,
//          ),
//          decoration: new InputDecoration(
//            filled: false,
//            hintText: hintText,
//            hintStyle: new TextStyle(
//              color: const Color(ColorConstants.primary_black),
//              fontSize: 18.0,
//            ),
//          ),
//        ),
      );
}

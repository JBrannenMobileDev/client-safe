import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType inputType;
  final double height;
  final String inputTypeError;
  final Function(String) onTextInputChanged;
  final Function() onEditingCompleted;
  final TextInputAction keyboardAction;
  final FocusNode focusNode;
  final Function onFocusAction;
  final TextCapitalization capitalization;
  final List<TextInputFormatter> inputFormatter;
  final bool enabled;
  final bool obscureText;
  int maxLines = 1;

  LoginTextField({
      this.controller,
      this.hintText,
      this.inputType,
      this.height,
      this.onTextInputChanged,
      this.inputTypeError,
      this.keyboardAction,
      this.focusNode,
      this.onFocusAction,
      this.capitalization,
      this.inputFormatter,
      this.labelText,
      this.onEditingCompleted,
      this.enabled,
      this.obscureText,
      this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0, bottom: 8.0),
          height: height,
          decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: TextFormField(
            obscureText: obscureText,
            cursorColor: Color(ColorConstants.getPrimaryColor()),
            enabled: enabled,
            focusNode: focusNode,
            textInputAction: keyboardAction,
            maxLines: maxLines,
            controller: controller,
            onChanged: (text) {
              onTextInputChanged(text);
            },
            onFieldSubmitted: (term) {
              onFocusAction();
            },
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              fillColor: Colors.white,
              hintStyle: new TextStyle(
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                  fontWeight: TextDandyLight.getFontWeight(),
                  color: Color(ColorConstants.getPrimaryBlack())),
            ),
            keyboardType: inputType,
            textCapitalization: capitalization,
            onEditingComplete: onEditingCompleted,
            inputFormatters: inputFormatter != null ? inputFormatter : null,
            style: new TextStyle(
                fontFamily: TextDandyLight.getFontFamily(),
                fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                fontWeight: TextDandyLight.getFontWeight(),
                color: Color(ColorConstants.getPrimaryBlack())),
            textAlignVertical: TextAlignVertical.center,
          )
    );
  }
}

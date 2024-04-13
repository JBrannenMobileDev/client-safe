import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'TextDandyLight.dart';

class DandyLightTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final double height;
  final String inputTypeError;
  final Function(String) onTextInputChanged;
  final TextInputAction keyboardAction;
  final FocusNode? focusNode;
  final Function onFocusAction;
  final TextCapitalization capitalization;
  final List<TextInputFormatter>? inputFormatter;
  final bool textFieldEnabled;

  DandyLightTextField(this.controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged, this.inputTypeError, this.keyboardAction,
      this.focusNode, this.onFocusAction, this.capitalization, this.inputFormatter, this.textFieldEnabled);

  @override
  Widget build(BuildContext context) {
    return Container(
              height: height,
              child: TextField(
                enabled: textFieldEnabled,
                focusNode: focusNode,
                textInputAction: keyboardAction,
                controller: controller,
                cursorColor: Color(ColorConstants.getBlueDark()),
                onChanged: (text) {
                  onTextInputChanged(text);
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                      fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                      fontFamily: TextDandyLight.getFontFamily(),
                      fontWeight: TextDandyLight.getFontWeight(),
                      color: Color(ColorConstants.getPrimaryBlack())
                  ),
                  hintText: hintText,
                  fillColor: Color(ColorConstants.getPrimaryWhite()),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                ),
                keyboardType: inputType,
                textCapitalization: capitalization,
                maxLines: 500,
                inputFormatters: inputFormatter != null ? inputFormatter : null,
                style: TextStyle(
                    fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                    fontFamily: TextDandyLight.getFontFamily(),
                    fontWeight: TextDandyLight.getFontWeight(),
                    color: textFieldEnabled ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBackgroundGrey())
                ),
              ),
    );
  }
}

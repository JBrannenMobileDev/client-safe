
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/TextDandyLight.dart';


class DandyLightLibraryTextField extends StatelessWidget {
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
  final double radius;

  DandyLightLibraryTextField({
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
      this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.center,
          margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
          height: height,
          child: TextFormField(
            enabled: enabled,
            focusNode: focusNode,
            textInputAction: keyboardAction,
            maxLines: 24,
            controller: controller,
            cursorColor: Color(ColorConstants.getPeachDark()),
            onChanged: (text) {
              onTextInputChanged(text);
            },
            onFieldSubmitted: (term) {
              onFocusAction();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 0),
              alignLabelWithHint: true,
              labelText: labelText,
              hintText: hintText,
              labelStyle: TextStyle(
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontWeight: TextDandyLight.getFontWeight(),
                  color: Color(ColorConstants.getPrimaryBlack())),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPeachDark()),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                  width: 1.0,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                  width: 1.0,
                ),
              ),
            ),
            keyboardType: inputType,
            textCapitalization: capitalization,
            onEditingComplete: onEditingCompleted,
            inputFormatters: inputFormatter != null ? inputFormatter : null,
            style: new TextStyle(
                fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
                fontFamily: TextDandyLight.getFontFamily(),
                fontWeight: TextDandyLight.getFontWeight(),
                color: Color(ColorConstants.getPrimaryBlack())),
          )
    );
  }
}

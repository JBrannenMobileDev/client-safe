import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';

class TextFieldDandylight extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? inputType;
  final double? height;
  final String? inputTypeError;
  final Function(String)? onTextInputChanged;
  final Function()? onEditingCompleted;
  final TextInputAction? keyboardAction;
  final FocusNode? focusNode;
  final Function? onFocusAction;
  final TextCapitalization? capitalization;
  final List<TextInputFormatter>? inputFormatter;
  final bool? enabled;
  final bool? obscureText;
  int? maxLines = 1;

  TextFieldDandylight({
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
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          height: height,
          decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: TextFormField(
            obscureText: obscureText ?? false,
            cursorColor: Color(ColorConstants.getBlueDark()),
            enabled: enabled,
            focusNode: focusNode,
            textInputAction: keyboardAction,
            maxLines: maxLines,
            controller: controller,
            onChanged: (text) {
              onTextInputChanged!(text);
            },
            onFieldSubmitted: (term) {
              if(onFocusAction != null) {
                onFocusAction!();
              }
            },
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              fillColor: Color(ColorConstants.getPrimaryWhite()),
              hintStyle: new TextStyle(
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                  fontWeight: TextDandyLight.getFontWeight(),
                  color: Color(ColorConstants.getBlueDark())),
            ),
            keyboardType: inputType,
            textCapitalization: capitalization ?? TextCapitalization.none,
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

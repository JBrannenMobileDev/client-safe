import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';


class ShareWithClientTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? inputType;
  final double? height;
  final String? inputTypeError;
  final Function(String)? onTextInputChanged;
  final TextInputAction? keyboardAction;
  final FocusNode? focusNode;
  final Function? onFocusAction;
  final TextCapitalization? capitalization;
  final List<TextInputFormatter>? inputFormatter;
  final bool? textFieldEnabled;
  final bool? showBorder;
  final bool? usePadding;

  ShareWithClientTextField(this.controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged, this.inputTypeError, this.keyboardAction,
      this.focusNode, this.onFocusAction, this.capitalization, this.inputFormatter, this.textFieldEnabled, this.showBorder, this.usePadding);

  @override
  Widget build(BuildContext context) {
    return Container(
              height: height,
              child: TextField(
                enabled: textFieldEnabled,
                focusNode: focusNode,
                textInputAction: keyboardAction,
                controller: controller,
                cursorColor: Color(ColorConstants.getPrimaryBlack()),
                onChanged: (text) {
                  onTextInputChanged!(text);
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
                  border: showBorder! ? OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(ColorConstants.getPeachDark()),
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(16)
                  ) : InputBorder.none,
                  focusedBorder: showBorder! ? OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(ColorConstants.getPeachDark()),
                        width: 2.0
                    ),
                      borderRadius: BorderRadius.circular(16)
                  ) : InputBorder.none,
                  enabledBorder: showBorder! ? OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(ColorConstants.getPeachDark()),
                        width: 2.0
                    ),
                      borderRadius: BorderRadius.circular(16)
                  ) : InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: usePadding! ? 16 : 0, top: usePadding! ? 16 : 0, right: usePadding! ? 16 : 0, bottom: 0),
                  isDense: true,
                ),
                keyboardType: inputType,
                textCapitalization: capitalization!,
                maxLines: 500,
                inputFormatters: inputFormatter != null ? inputFormatter : null,
                style: TextStyle(
                    fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
                    fontFamily: TextDandyLight.getFontFamily(),
                    fontWeight: TextDandyLight.getFontWeight(),
                    color: textFieldEnabled! ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBackgroundGrey())
                ),
              ),
    );
  }
}

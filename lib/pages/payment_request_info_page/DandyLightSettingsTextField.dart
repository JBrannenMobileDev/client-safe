import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';

class DandyLightSettingsTextField extends StatelessWidget {
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
  final int? maxLines;

  DandyLightSettingsTextField({
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
      this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
          margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
          height: height,
          child: TextFormField(
            enabled: enabled,
            focusNode: focusNode,
            textInputAction: keyboardAction,
            maxLines: maxLines,
            controller: controller,
            onChanged: (text) async {
              await onTextInputChanged!(text);
              onFocusAction!();
            },
            onFieldSubmitted: (term) {

            },
            cursorColor: Color(ColorConstants.getPrimaryColor()),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: labelText,
              hintText: hintText,
              fillColor: Color(ColorConstants.getPrimaryWhite()),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getBlueDark()),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getBlueDark()),
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getBlueDark()),
                  width: 1.0,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getBlueDark()),
                  width: 1.0,
                ),
              ),
            ),
            keyboardType: inputType,
            textCapitalization: capitalization!,
            onEditingComplete: onEditingCompleted,
            inputFormatters: inputFormatter != null ? inputFormatter : null,
            style: new TextStyle(
                fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                fontFamily: TextDandyLight.getFontFamily(),
                fontWeight: TextDandyLight.getFontWeight(),
                color: Color(ColorConstants.getPrimaryBlack())),
          )
    );
  }
}

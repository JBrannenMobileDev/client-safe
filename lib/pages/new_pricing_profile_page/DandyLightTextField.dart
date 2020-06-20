import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DandyLightTextField extends StatelessWidget {
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

  DandyLightTextField({
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
            maxLines: 24,
            controller: controller,
            onChanged: (text) {
              onTextInputChanged(text);
            },
            onFieldSubmitted: (term) {
              onFocusAction();
            },
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: labelText,
              hintText: hintText,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryColor()),
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryColor()),
                  width: 1.0,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryColor()),
                  width: 1.0,
                ),
              ),
            ),
            keyboardType: inputType,
            textCapitalization: capitalization,
            onEditingComplete: onEditingCompleted,
            inputFormatters: inputFormatter != null ? inputFormatter : null,
            style: new TextStyle(
                fontFamily: 'simple',
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Color(ColorConstants.getPrimaryBlack())),
          )
    );
  }
}

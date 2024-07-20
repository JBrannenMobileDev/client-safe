import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class TextFieldSimple extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? inputType;
  final double? height;
  final bool? hasError;
  final Function(String)? onTextInputChanged;
  final Function()? onEditingCompleted;
  final TextInputAction? keyboardAction;
  final FocusNode? focusNode;
  final Function? onFocusAction;
  final TextCapitalization? capitalization;
  final List<TextInputFormatter>? inputFormatter;
  final bool? enabled;

  TextFieldSimple({
      this.controller,
      this.hintText,
      this.inputType,
      this.height,
      this.onTextInputChanged,
      this.hasError,
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
          margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          height: 48,
          child: TextFormField(
            cursorColor: Color(ColorConstants.getPrimaryBlack()),
            enabled: enabled,
            focusNode: focusNode,
            textInputAction: keyboardAction,
            maxLines: 24,
            controller: controller,
            onChanged: (text) {
              onTextInputChanged!(text);
            },
            onFieldSubmitted: (term) {
              if(onFocusAction != null) {
                onFocusAction!();
              }
            },
            decoration: InputDecoration(
              alignLabelWithHint: true,
              hintText: hintText,
              filled: true,
              contentPadding: const EdgeInsets.only(
                  left: 16.0,
                  bottom: 0.0,
                  top: 24.0),
              fillColor: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryGreyDark()),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: (hasError ?? false) ? const Color(ColorConstants.error_red) : Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                  width: (hasError ?? false) ? 2.0 : 0,
                ),
              ),
            ),
            keyboardType: inputType,
            textCapitalization: capitalization ?? TextCapitalization.none,
            onEditingComplete: onEditingCompleted,
            inputFormatters: inputFormatter,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            style: TextStyle(
                fontFamily: TextDandyLight.getFontFamily(),
                fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
                fontWeight: TextDandyLight.getFontWeight(),
                color: Color(ColorConstants.getPrimaryBlack())),
          )
    );
  }
}

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../widgets/TextDandyLight.dart';

class NewJobTextField extends StatelessWidget {
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

  NewJobTextField({
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
      this.inputFormatter
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
          height: height,
          color: Colors.transparent,
          child: TextFormField(
            autofocus: true,
            focusNode: focusNode,
            textInputAction: keyboardAction,
            maxLines: 24,
            controller: controller,
            onChanged: (text) {
              onTextInputChanged!(text);
            },
            onFieldSubmitted: (term) {
              onFocusAction!();
            },
            cursorColor: Color(ColorConstants.getBlueDark()),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: 16.0,
                  bottom: 0.0,
                  top: 24.0),
              suffixIcon: Icon(Icons.search, color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5)),
              alignLabelWithHint: true,
              labelText: hintText,
              labelStyle: TextStyle(
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontWeight: TextDandyLight.getFontWeight(),
                  color: Color(ColorConstants.getPrimaryBlack())),
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontWeight: TextDandyLight.getFontWeight(),
                  color: Color(ColorConstants.getBlueLight())),
              fillColor: Color(ColorConstants.getPrimaryWhite()),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
                  width: 1.0,
                ),
              ),
            ),
            keyboardType: inputType,
            textCapitalization: capitalization!,
            inputFormatters: inputFormatter != null ? inputFormatter : null,
            style: TextStyle(
              fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
              fontFamily: TextDandyLight.getFontFamily(),
              fontWeight: TextDandyLight.getFontWeight(),
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          )),
    );
  }
}

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'ClientDetailsPageState.dart';

class ContactDetailsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final double height;
  final String inputTypeError;
  final Function(String) onTextInputChanged;
  final TextInputAction keyboardAction;
  final FocusNode focusNode;
  final Function onFocusAction;
  final TextCapitalization capitalization;
  final List<TextInputFormatter> inputFormatter;
  final bool textFieldEnabled;

  ContactDetailsTextField(this.controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged, this.inputTypeError, this.keyboardAction,
      this.focusNode, this.onFocusAction, this.capitalization, this.inputFormatter, this.textFieldEnabled);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientDetailsPageState>(
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) =>
          Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: height,
              child: TextFormField(
                enabled: textFieldEnabled,
                focusNode: focusNode,
                textInputAction: keyboardAction,
                maxLines: 24,
                controller: controller,
                cursorColor: Color(ColorConstants.getPrimaryColor()),
                onChanged: (text) {
                  onTextInputChanged(text);
                },
                onFieldSubmitted: (term){
                  onFocusAction();
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: hintText,
                  labelStyle: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryBlack())
                  ),
                  hintText: hintText,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: textFieldEnabled ? Color(ColorConstants.getPrimaryColor()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: textFieldEnabled ? Color(ColorConstants.getPrimaryColor()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                      width: 1.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: textFieldEnabled ? Color(ColorConstants.getPrimaryColor()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: textFieldEnabled ? Color(ColorConstants.getPrimaryColor()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: inputType,
                textCapitalization: capitalization,
                inputFormatters: inputFormatter != null ? inputFormatter : null,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: textFieldEnabled ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPrimaryBackgroundGrey())
                ),
              )),
    );
  }
}

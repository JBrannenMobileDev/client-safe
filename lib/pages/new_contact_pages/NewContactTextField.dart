import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewContactTextField extends StatelessWidget {
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

  NewContactTextField(this.controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged, this.inputTypeError, this.keyboardAction,
      this.focusNode, this.onFocusAction, this.capitalization, this.inputFormatter, this.textFieldEnabled);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: height,
              child: TextFormField(
                enabled: textFieldEnabled,
                focusNode: focusNode,
                textInputAction: keyboardAction,
                maxLines: 24,
                controller: controller,
                onChanged: (text) {
                  onTextInputChanged(text);
                  pageState.onErrorStateChanged(NewContactPageState.NO_ERROR);
                },
                onFieldSubmitted: (term){
                  onFocusAction();
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: hintText,
                  hintText: hintText,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: pageState.errorState !=
                                  NewContactPageState.NO_ERROR &&
                              inputTypeError == pageState.errorState
                          ? Colors.red
                          : textFieldEnabled ? Color(ColorConstants.getPrimaryColor()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                      width: 1.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: pageState.errorState !=
                          NewContactPageState.NO_ERROR &&
                          inputTypeError == pageState.errorState
                          ? Colors.red
                          : textFieldEnabled ? Color(ColorConstants.getPrimaryColor()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: pageState.errorState !=
                          NewContactPageState.NO_ERROR &&
                          inputTypeError == pageState.errorState
                          ? Colors.red
                          : textFieldEnabled ? Color(ColorConstants.getPrimaryColor()) : Color(ColorConstants.getPrimaryBackgroundGrey()),
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

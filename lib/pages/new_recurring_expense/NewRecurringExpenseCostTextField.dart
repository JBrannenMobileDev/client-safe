import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NewRecurringExpenseCostTextField extends StatelessWidget {
  final TextEditingController _controller;
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

  NewRecurringExpenseCostTextField(this._controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged, this.inputTypeError, this.keyboardAction,
      this.focusNode, this.onFocusAction, this.capitalization, this.inputFormatter);

  @override
  Widget build(BuildContext context) {
    return Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: height,
              width: 200.0,
              child: TextFormField(
                cursorColor: Colors.transparent,
                focusNode: focusNode,
                textInputAction: keyboardAction,
                textAlign: TextAlign.center,
                enableInteractiveSelection: false,
                maxLines: 24,
                controller: _controller,
                onChanged: (text) {
                  onTextInputChanged(text);
                  HapticFeedback.heavyImpact();
                },
                onFieldSubmitted: (term){
                  onFocusAction();
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Cost',
                  hintText: hintText,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                      color: Color(ColorConstants.getPrimaryColor())
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryColor()),
                      width: 1.0,
                    ),
                  ),
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
                inputFormatters: inputFormatter != null ? inputFormatter : null,
                style: new TextStyle(
                    fontSize: 32.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black)),
              )
    );
  }
}

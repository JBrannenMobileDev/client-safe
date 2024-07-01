import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class CostTextField extends StatelessWidget {
  final TextEditingController? _controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? inputType;
  final double? height;
  final String? inputTypeError;
  final Function(String)? onTextInputChanged;
  final TextInputAction? keyboardAction;
  final FocusNode? focusNode;
  final Function? onFocusAction;
  final TextCapitalization? capitalization;
  final List<TextInputFormatter>? inputFormatter;
  final double? width;
  final bool? enabled;

  CostTextField(this._controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged, this.inputTypeError, this.keyboardAction,
      this.focusNode, this.onFocusAction, this.capitalization, this.inputFormatter, this.labelText, this.width, this.enabled);

  @override
  Widget build(BuildContext context) {
    return Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: height,
              width: width == null ? 250 : width,
              child: TextFormField(
                enabled: enabled,
                cursorColor: Color(ColorConstants.getBlueDark()),
                focusNode: focusNode,
                textInputAction: keyboardAction,
                textAlign: TextAlign.center,
                enableInteractiveSelection: false,
                maxLines: 24,
                controller: _controller,
                onChanged: (text) {
                  onTextInputChanged!(text);
                  HapticFeedback.heavyImpact();
                },
                onFieldSubmitted: (term){
                  if(onFocusAction != null) {
                    onFocusAction!();
                  }
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: labelText,
                  hintText: hintText,
                  fillColor: Color(ColorConstants.getPrimaryWhite()),
                  labelStyle: TextStyle(
                    color: Color(ColorConstants.getBlueLight()),
                    fontSize: TextDandyLight.getFontSize(TextDandyLight.LARGE_TEXT),
                    fontFamily: TextDandyLight.getFontFamily(),
                    fontWeight: TextDandyLight.getFontWeight(),
                  ),
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
                      color: Color(ColorConstants.getBlueLight()),
                      width: 1.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Color(ColorConstants.getBlueLight()),
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Color(ColorConstants.getBlueLight()),
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: inputType,
                textCapitalization: capitalization!,
                inputFormatters: inputFormatter != null ? inputFormatter : null,
                style: new TextStyle(
                    fontSize: TextDandyLight.getFontSize(TextDandyLight.LARGE_TEXT),
                    fontFamily: TextDandyLight.getFontFamily(),
                    fontWeight: TextDandyLight.getFontWeight(),
                    color: Color(enabled! ? ColorConstants.getPrimaryBlack() : ColorConstants.getBlueLight())),
              )
    );
  }
}

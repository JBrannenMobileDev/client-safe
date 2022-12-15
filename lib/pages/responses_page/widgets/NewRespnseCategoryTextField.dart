import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_pose_group_page/NewPoseGroupPageState.dart';
import 'package:dandylight/pages/responses_page/ResponsesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewResponseCategoryTextField extends StatelessWidget {
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

  NewResponseCategoryTextField(this._controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged, this.inputTypeError, this.keyboardAction,
      this.focusNode, this.onFocusAction, this.capitalization, this.inputFormatter);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResponsesPageState>(
      converter: (store) => ResponsesPageState.fromStore(store),
      builder: (BuildContext context, ResponsesPageState pageState) =>
          Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: height,
              child: TextFormField(
                cursorColor: Color(ColorConstants.getBlueLight()),
                focusNode: focusNode,
                textInputAction: keyboardAction,
                maxLines: 24,
                controller: _controller,
                onChanged: (text) {
                  onTextInputChanged(text);
                },
                onFieldSubmitted: (term){
                  onFocusAction();
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: hintText,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Color(ColorConstants.getBlueLight()),
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
                textCapitalization: capitalization,
                inputFormatters: inputFormatter != null ? inputFormatter : null,
                style: new TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black)),
              )),
    );
  }
}

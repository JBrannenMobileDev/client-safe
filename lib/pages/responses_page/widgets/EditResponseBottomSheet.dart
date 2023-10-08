import 'package:dandylight/pages/responses_page/ResponsesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/widgets/DandyLightTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../AppState.dart';
import '../../../models/ResponsesListItem.dart';
import '../../../widgets/TextDandyLight.dart';


class EditResponseBottomSheet extends StatefulWidget {
  final ResponsesListItem response;

  EditResponseBottomSheet(this.response);

  @override
  State<StatefulWidget> createState() {
    return _EditResponsePageState(response);
  }
}

class _EditResponsePageState extends State<EditResponseBottomSheet> {
  final TitleTextController = TextEditingController();
  final MessageTextController = TextEditingController();
  final ResponsesListItem response;

  _EditResponsePageState(this.response);

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ResponsesPageState>(
      onInit: (store) {
        TitleTextController.text = response.response.title;
        MessageTextController.text = response.response.message;
      },
      converter: (store) => ResponsesPageState.fromStore(store),
      builder: (BuildContext context, ResponsesPageState modalPageState) =>
         Container(
           height: 750,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              color: Color(ColorConstants.getBlueLight())),
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Cancel',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          modalPageState.onUpdateResponseSelected(response);
                          Navigator.of(context).pop();
                        },
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Save',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 16.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Edit Response',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Title',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(bottom: 8, left: 16, right: 16, top: 18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(ColorConstants.getPrimaryWhite()).withOpacity(0.5)
                ),
                child: DandyLightTextField(
                  TitleTextController,
                  "",
                  TextInputType.text,
                  42.0,
                  _onTitleChanged,
                  'noError',
                  TextInputAction.next,
                  null,
                  onTitleAction,
                  TextCapitalization.words,
                  null,
                  true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32, bottom: 8),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Response',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 8, left: 16, right: 16, top: 8),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(ColorConstants.getPrimaryWhite()).withOpacity(0.5)
                ),
                child: DandyLightTextField(
                  MessageTextController,
                  '{Your personal message goes here}',
                  TextInputType.text,
                  450.0,
                  _onMessageChanged,
                  'noError',
                  TextInputAction.done,
                  null,
                  onMessageAction,
                  TextCapitalization.sentences,
                  null,
                  true,
                ),
              ),
            ],
          ),
        ),
    );
  }

  void onTitleAction(){
    // _TitleFocusNode.unfocus();
  }

  void onMessageAction(){
    // _ResponseFocusNode.unfocus();
  }

  _onMessageChanged(String responseMessage) {
    response.response.message = responseMessage;
  }

  _onTitleChanged(String title) {
    response.response.title = title;
    response.title = title;
  }
}

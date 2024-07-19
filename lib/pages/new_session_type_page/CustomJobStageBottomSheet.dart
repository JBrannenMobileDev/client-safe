import 'package:dandylight/pages/new_session_type_page/NewSessionTypePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../widgets/TextDandyLight.dart';
import 'DandyLightTextField.dart';


class CustomJobStageBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CustomJobStageBottomSheetState();
  }
}

class _CustomJobStageBottomSheetState extends State<CustomJobStageBottomSheet> with TickerProviderStateMixin {
  final descriptionTextController = TextEditingController();


  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewSessionTypePageState>(
        converter: (Store<AppState> store) =>
            NewSessionTypePageState.fromStore(store),
        builder: (BuildContext context, NewSessionTypePageState pageState) =>
            Container(
              height: 284,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0)),
                  color: Color(ColorConstants.getPrimaryWhite())),
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(bottom: 32, left: 12, right: 12),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'New Custom Stage',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 116, left: 16, right: 16),
                    child: DandyLightTextField(
                      controller: descriptionTextController,
                      hintText: 'Stage name',
                      inputType: TextInputType.text,
                      focusNode: null,
                      onFocusAction: null,
                      height: 84.0,
                      maxLength: 20,
                      onTextInputChanged: pageState.onCustomStageNameChanged,
                      keyboardAction: TextInputAction.done,
                      capitalization: TextCapitalization.words,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(pageState.newStageName != null && pageState.newStageName!.length > 0) {
                        pageState.saveNewStage!();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 32),
                      alignment: Alignment.center,
                      height: 54,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: Color(ColorConstants.getPeachDark())
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Save stage',
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ],
              )
            ),
      );
}
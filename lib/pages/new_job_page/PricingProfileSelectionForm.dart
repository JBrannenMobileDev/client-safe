import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobPriceProfileListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/InputDoneView.dart';
import '../../utils/flutter_masked_text.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_pricing_profile_page/DandyLightTextField.dart';

class PricingProfileSelectionForm extends StatefulWidget {
  @override
  _PricingProfileSelectionFormState createState() {
    return _PricingProfileSelectionFormState();
  }
}

class _PricingProfileSelectionFormState
    extends State<PricingProfileSelectionForm>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final FocusNode flatRateInputFocusNode = new FocusNode();
  var flatRateTextController = MoneyMaskedTextController(leftSymbol: '\$ ', decimalSeparator: '.', thousandSeparator: ',', precision: 2);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        if(store.state.newJobPageState!.oneTimePrice!.isNotEmpty) {
          flatRateTextController.text = (store.state.newJobPageState!.oneTimePrice!);
        }
        flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
        flatRateInputFocusNode.addListener(() {
          flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
         });
        },
      onDidChange: (previous, current) {
        flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        child: pageState.pricingProfiles!.length > 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 0.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "Input a one time price.\nOr select a price package for this job.",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 65.0,
                      maxHeight: 486.0,
                    ),
                    child: ListView.builder(
                      reverse: false,
                      padding: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 64.0),
                      shrinkWrap: true,
                      controller: _controller,
                      physics: ClampingScrollPhysics(),
                      key: _listKey,
                      itemCount: pageState.pricingProfiles!.length +1,
                      itemBuilder: _buildItem,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 32.0, top: 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "Input a one time price.\nOr select a Price Package for this job.",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: DandyLightTextField(
                      controller: flatRateTextController,
                      hintText: "\$",
                      inputType: const TextInputType.numberWithOptions(signed: true),
                      focusNode: flatRateInputFocusNode,
                      height: 60.0,
                      onTextInputChanged: pageState.onOneTimePriceChanged!,
                      capitalization: TextCapitalization.none,
                      keyboardAction: TextInputAction.done,
                      labelText: 'One time price',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 64.0, top: 32),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "You do not have any price packages saved yet. "
                      "Select the + to create a new pricing package.",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget
  _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: index == 0 ? Container(
          padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
          child: Column(
            children: [
              DandyLightTextField(
                controller: flatRateTextController,
                hintText: "\$ 0",
                inputType: const TextInputType.numberWithOptions(signed: true),
                focusNode: flatRateInputFocusNode,
                height: 66.0,
                onTextInputChanged: pageState.onOneTimePriceChanged!,
                capitalization: TextCapitalization.none,
                keyboardAction: TextInputAction.done,
                labelText: 'One time price',
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0, top: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: "Or",
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
            ],
          ),
        ) : NewJobPriceProfileListWidget(
              pageState.pricingProfiles!.elementAt(index - 1),
              pageState,
              onProfileSelected,
              pageState.selectedPriceProfile?.documentId == pageState.pricingProfiles!.elementAt(index - 1).documentId && pageState.oneTimePrice!.isEmpty ? Color(ColorConstants.getPrimaryBackgroundGrey()) : Color(ColorConstants.getPrimaryWhite()),
              Color(ColorConstants.getPrimaryBlack())),
      ),
    );
  }

  onProfileSelected(PriceProfile priceProfile, var pageState, BuildContext context) {
    pageState.onPriceProfileSelected(priceProfile);
  }

  @override
  bool get wantKeepAlive => true;
}

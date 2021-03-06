import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/pricing_profiles_page/widgets/PriceProfileListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        child: pageState.pricingProfiles.length > 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Text(
                      "Select a price package for this job.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 65.0,
                      maxHeight: 350.0,
                    ),
                    child: ListView.builder(
                      reverse: false,
                      padding: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 64.0),
                      shrinkWrap: true,
                      controller: _controller,
                      physics: ClampingScrollPhysics(),
                      key: _listKey,
                      itemCount: pageState.pricingProfiles.length,
                      itemBuilder: _buildItem,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0, top: 8.0),
                    child: Text(
                      "Select a Price Package for this job",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      "A pricing package includes information on price, length of session, "
                      "and number of edits. You do not have any pricing packages setup. "
                      "Select the button below to create a new pricing package.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  ClientSafeButton(
                    height: 64.0,
                    width: double.infinity,
                    text: "Pricing Package",
                    marginLeft: 32.0,
                    marginTop: 0.0,
                    marginRight: 32.0,
                    marginBottom: 0.0,
                    onPressed: () {
                      UserOptionsUtil.showNewPriceProfileDialog(context);
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    urlText: "",
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: PriceProfileListWidget(
            pageState.pricingProfiles.elementAt(index),
            pageState,
            onProfileSelected,
            pageState.selectedPriceProfile == pageState.pricingProfiles.elementAt(index)
                ? Color(ColorConstants.getBlueDark())
                : Colors.white,pageState.selectedPriceProfile == pageState.pricingProfiles.elementAt(index)
            ? Color(ColorConstants.getPrimaryWhite())
            : Color(ColorConstants.getPrimaryBlack())),
      ),
    );
  }

  onProfileSelected(
      PriceProfile priceProfile, var pageState, BuildContext context) {
    pageState.onPriceProfileSelected(priceProfile);
  }

  @override
  bool get wantKeepAlive => true;
}

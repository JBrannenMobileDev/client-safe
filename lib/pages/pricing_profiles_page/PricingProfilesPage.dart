import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:dandylight/pages/pricing_profiles_page/widgets/PriceProfileListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../widgets/TextDandyLight.dart';

class PricingProfilesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PricingProfilesPageState();
  }
}

class _PricingProfilesPageState extends State<PricingProfilesPage> with TickerProviderStateMixin {
  ScrollController _scrollController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, PricingProfilesPageState>(
        onInit: (store) {
          store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
        },
        converter: (Store<AppState> store) => PricingProfilesPageState.fromStore(store),
        builder: (BuildContext context, PricingProfilesPageState pageState) =>
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      iconTheme: IconThemeData(
                        color: Color(ColorConstants.getBlueDark()), //change your color here
                      ),
                      brightness: Brightness.light,
                      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                      pinned: true,
                      centerTitle: true,
                      elevation: 0.0,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Pricing Packages",
                        color: Color(ColorConstants.getBlueDark()),
                      ),
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            UserOptionsUtil.showNewPriceProfileDialog(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 24.0),
                            height: 28.0,
                            width: 28.0,
                            child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getBlueDark()),),
                          ),
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: new SliverChildListDelegate(
                        <Widget>[
                          pageState.pricingProfiles.length > 0 ? ListView.builder(
                            reverse: false,
                            padding: new EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 64.0),
                            shrinkWrap: true,
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            key: _listKey,
                            itemCount: pageState.pricingProfiles.length,
                            itemBuilder: _buildItem,
                          ) :
                          Padding(
                            padding: EdgeInsets.only(left: 64.0, top: 48.0, right: 64.0),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: "You have not created any pricing package yet. To create a new pricing package, select the plus icon.",
                              textAlign: TextAlign.center,
                              color:  Color(ColorConstants.getBlueDark()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, PricingProfilesPageState>(
      converter: (store) => PricingProfilesPageState.fromStore(store),
      builder: (BuildContext context, PricingProfilesPageState pageState) =>
          Container(
            margin: EdgeInsets.only(top: 0.0, bottom: 8.0),
            child: PriceProfileListWidget(pageState.pricingProfiles.elementAt(index), pageState, onProfileSelected, Color(ColorConstants.getBlueLight()), Color(ColorConstants.getPrimaryBlack())),
          ),
    );
  }

  onProfileSelected(PriceProfile priceProfile, PricingProfilesPageState pageState,  BuildContext context) {
    pageState.onProfileSelected(priceProfile);
    UserOptionsUtil.showNewPriceProfileDialog(context);
  }
}

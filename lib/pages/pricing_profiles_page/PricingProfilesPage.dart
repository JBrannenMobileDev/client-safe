import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:client_safe/pages/pricing_profiles_page/widgets/PriceProfileListWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PricingProfilesPage extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, PricingProfilesPageState>(
        converter: (Store<AppState> store) => PricingProfilesPageState.fromStore(store),
        builder: (BuildContext context, PricingProfilesPageState pageState) =>
            Scaffold(
              backgroundColor: Color(ColorConstants.primary_pricing_profile),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    brightness: Brightness.dark,
                    backgroundColor: Color(ColorConstants.primary_pricing_profile),
                    pinned: true,
                    centerTitle: true,
                    title: Center(
                      child: Text(
                        "Pricing Profiles",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: const Color(ColorConstants.white),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: Color(ColorConstants.white),
                        tooltip: 'Add',
                        onPressed: () {
                          UserOptionsUtil.showNewPriceProfileDialog(context);
                        },
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        ListView.builder(
                          reverse: false,
                          padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                          shrinkWrap: true,
                          controller: _controller,
                          physics: ClampingScrollPhysics(),
                          key: _listKey,
                          itemCount: pageState.pricingProfiles.length,
                          itemBuilder: _buildItem,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, PricingProfilesPageState>(
      converter: (store) => PricingProfilesPageState.fromStore(store),
      builder: (BuildContext context, PricingProfilesPageState pageState) =>
          PriceProfileListWidget(index),
    );
  }
}

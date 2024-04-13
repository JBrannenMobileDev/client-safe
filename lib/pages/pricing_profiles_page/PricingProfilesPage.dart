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
  ScrollController? _scrollController;
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
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          pageState.pricingProfiles!.length > 0 ? ListView.builder(
                            reverse: false,
                            padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 64.0),
                            shrinkWrap: true,
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            key: _listKey,
                            itemCount: pageState.pricingProfiles!.length,
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
            child: PriceProfileListWidget(pageState.pricingProfiles!.elementAt(index), pageState, onProfileSelected, Color(ColorConstants.getBlueLight()), Color(ColorConstants.getPrimaryBlack())),
          ),
    );
  }

  onProfileSelected(PriceProfile priceProfile, PricingProfilesPageState pageState,  BuildContext context) {
    pageState.onProfileSelected!(priceProfile);
    UserOptionsUtil.showNewPriceProfileDialog(context);
  }

  bool get _isMinimized {
    return _scrollController!.hasClients && _scrollController!.offset > 260.0;
  }

  Color _getAppBarColor() {
    if (_scrollController!.offset > 260 && _scrollController!.offset <= 262) {
      return Colors.black.withOpacity(0.08);
    } else if (_scrollController!.offset > 262 &&
        _scrollController!.offset <= 263) {
      return Colors.black.withOpacity(0.09);
    } else if (_scrollController!.offset > 263 &&
        _scrollController!.offset <= 264) {
      return Colors.black.withOpacity(0.10);
    } else if (_scrollController!.offset > 264 &&
        _scrollController!.offset <= 265) {
      return Colors.black.withOpacity(0.11);
    } else if (_scrollController!.offset > 265 &&
        _scrollController!.offset <= 266) {
      return Colors.black.withOpacity(0.12);
    } else if (_scrollController!.offset > 266 &&
        _scrollController!.offset <= 267) {
      return Colors.black.withOpacity(0.13);
    } else if (_scrollController!.offset > 267 &&
        _scrollController!.offset <= 268) {
      return Colors.black.withOpacity(0.15);
    } else if (_scrollController!.offset > 268 &&
        _scrollController!.offset <= 269) {
      return Colors.black.withOpacity(0.17);
    } else if (_scrollController!.offset > 269 &&
        _scrollController!.offset <= 270) {
      return Colors.black.withOpacity(0.19);
    } else if (_scrollController!.offset > 270 &&
        _scrollController!.offset <= 271) {
      return Colors.black.withOpacity(0.22);
    } else if (_scrollController!.offset > 271 &&
        _scrollController!.offset <= 272) {
      return Colors.black.withOpacity(0.19);
    }else if (_scrollController!.offset > 272 &&
        _scrollController!.offset <= 273) {
      return Colors.black.withOpacity(0.20);
    }else if (_scrollController!.offset > 273 &&
        _scrollController!.offset <= 274) {
      return Colors.black.withOpacity(0.21);
    }else if (_scrollController!.offset > 274 &&
        _scrollController!.offset <= 275) {
      return Colors.black.withOpacity(0.22);
    }else if (_scrollController!.offset > 275 &&
        _scrollController!.offset <= 276) {
      return Colors.black.withOpacity(0.23);
    }else if (_scrollController!.offset > 276 &&
        _scrollController!.offset <= 277) {
      return Colors.black.withOpacity(0.24);
    }else if (_scrollController!.offset > 277 &&
        _scrollController!.offset <= 278) {
      return Colors.black.withOpacity(0.25);
    }else if (_scrollController!.offset > 278 &&
        _scrollController!.offset <= 279) {
      return Colors.black.withOpacity(0.26);
    }else if (_scrollController!.offset > 279 &&
        _scrollController!.offset <= 280) {
      return Colors.black.withOpacity(0.27);
    }else if (_scrollController!.offset > 280 &&
        _scrollController!.offset <= 281) {
      return Colors.black.withOpacity(0.28);
    }else if (_scrollController!.offset > 281 &&
        _scrollController!.offset <= 282) {
      return Colors.black.withOpacity(0.29);
    }else if (_scrollController!.offset > 282 &&
        _scrollController!.offset <= 283) {
      return Colors.black.withOpacity(0.30);
    }else if (_scrollController!.offset > 283 &&
        _scrollController!.offset <= 284) {
      return Colors.black.withOpacity(0.32);
    }else if (_scrollController!.offset > 284 &&
        _scrollController!.offset <= 285) {
      return Colors.black.withOpacity(0.33);
    }else if (_scrollController!.offset > 285 &&
        _scrollController!.offset <= 286) {
      return Colors.black.withOpacity(0.343);
    }else if (_scrollController!.offset > 286 &&
        _scrollController!.offset <= 287) {
      return Colors.black.withOpacity(0.35);
    }else if (_scrollController!.offset > 287 &&
        _scrollController!.offset <= 288) {
      return Colors.black.withOpacity(0.36);
    }else if (_scrollController!.offset > 288 &&
        _scrollController!.offset <= 289) {
      return Colors.black.withOpacity(0.37);
    }else if (_scrollController!.offset > 289 &&
        _scrollController!.offset <= 290) {
      return Colors.black.withOpacity(0.38);
    }else if (_scrollController!.offset > 290 &&
        _scrollController!.offset <= 291) {
      return Colors.black.withOpacity(0.39);
    }
    return Colors.black.withOpacity(0.40);
  }
}

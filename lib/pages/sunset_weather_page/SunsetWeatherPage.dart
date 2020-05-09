import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPageState.dart';
import 'package:client_safe/pages/clients_page/widgets/ClientListWidget.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sider_bar/sider_bar.dart';

class SunsetWeatherPage extends StatefulWidget {
  static const String FILTER_TYPE_EVENING = "Evening";
  static const String FILTER_TYPE_MORNING = "Morning";

  @override
  State<StatefulWidget> createState() {
    return _SunsetWeatherPageState();
  }
}

class _SunsetWeatherPageState extends State<SunsetWeatherPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();
  int selectorIndex = 0;
  Map<int, Widget> filterTitles;

  @override
  Widget build(BuildContext context) {
    filterTitles = <int, Widget>{
      0: Text(SunsetWeatherPage.FILTER_TYPE_EVENING,
        style: TextStyle(
          fontFamily: 'simple',
          fontSize: 20.0,
          fontWeight: selectorIndex == 0 ? FontWeight.w800 : FontWeight.w600,
          color: Color(selectorIndex == 0
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),
      ),
      1: Text(SunsetWeatherPage.FILTER_TYPE_MORNING,
        style: TextStyle(
          fontFamily: 'simple',
          fontSize: 20.0,
          fontWeight: selectorIndex == 1 ? FontWeight.w800 : FontWeight.w600,
          color: Color(selectorIndex == 1
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
    };
    return StoreConnector<AppState, ClientsPageState>(
        onInit: (store) => store.dispatch(FetchClientData(store.state.clientsPageState)),
        converter: (store) => ClientsPageState.fromStore(store),
        builder: (BuildContext context, ClientsPageState pageState) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Colors.white,
                        pinned: true,
                        centerTitle: true,
                        title: Container(
                          child: Text(
                            "Sunset & Weather",
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        bottom: PreferredSize(
                          child: Container(
                            width: 225.0,
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              thumbColor: Color(ColorConstants.getPrimaryColor()),
                              children: filterTitles,
                              onValueChanged: (int filterTypeIndex) {
                                setState(() {
                                  selectorIndex = filterTypeIndex;
                                });
//                                pageState.onFilterChanged(filterTypeIndex == 0 ? SunsetWeatherPage.FILTER_TYPE_EVENING : SunsetWeatherPage.FILTER_TYPE_MORNING);
                              },
                              groupValue: selectorIndex,
                            ),
                          ),
                          preferredSize: Size.fromHeight(44.0),
                        ),
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  height: MediaQuery.of(context).size.width/4,
                                  width: MediaQuery.of(context).size.width/4,
                                  decoration: BoxDecoration(
//                                color: getCircleColor(index),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset('assets/images/icons/sunny_icon.png'),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16, left: 32.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 124.0,
                                            child: Text(
                                              'Sunny',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'simple',
                                                color: const Color(ColorConstants.primary_black),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 44.0,
                                            child: Text(
                                              '87° F',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'simple',
                                                color: const Color(ColorConstants.primary_black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 124.0,
                                            child: Text(
                                            'Chance of rain:',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'simple',
                                              color: const Color(ColorConstants.primary_black),
                                            ),
                                          ),
                                          ),
                                          Container(
                                            width: 44.0,
                                            child: Text(
                                              '2%',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'simple',
                                                color: const Color(ColorConstants.primary_black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 124.0,
                                            child: Text(
                                            'Cloud coverage:',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'simple',
                                              color: const Color(ColorConstants.primary_black),
                                            ),
                                          ),
                                          ),
                                          Container(
                                            width: 44.0,
                                            child: Text(
                                            '0%',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'simple',
                                              color: const Color(ColorConstants.primary_black),
                                            ),
                                          ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
          ),
        ),
      );
  }
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, ClientsPageState>(
    converter: (store) => ClientsPageState.fromStore(store),
    builder: (BuildContext context, ClientsPageState pageState) =>
        SizedBox(),
  );
}

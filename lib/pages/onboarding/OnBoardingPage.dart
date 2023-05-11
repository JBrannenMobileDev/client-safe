import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/TextDandyLight.dart';
import 'DoYouHaveAJobPage.dart';
import 'FeatureSelectionPage.dart';
import 'OnBoardingPageState.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnBoardingPageState();
  }
}

class _OnBoardingPageState extends State<OnBoardingPage> with TickerProviderStateMixin {
  ScrollController _scrollController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final int pageCount = 7;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    currentPageIndex = 0;
    controller.addListener(() {
      currentPageIndex = controller.page.toInt();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, OnBoardingPageState>(
        onInit: (store) {

        },
        onDidChange: (previous, current) {
          if(currentPageIndex != current.pagerIndex) {
            controller.animateToPage(current.pagerIndex, duration: Duration(milliseconds: 500),
                curve: Curves.ease);
          }
        },
        converter: (Store<AppState> store) => OnBoardingPageState.fromStore(store),
        builder: (BuildContext context, OnBoardingPageState pageState) =>
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView(
                      controller: controller,
                      pageSnapping: true,
                      physics:new NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        FeatureSelectionPage(),
                        DoYouHaveAJobPage(),
                      ],
                      onPageChanged: (index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 16.0, top: 72),
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height,
                      width: 250,
                      child: AnimatedSmoothIndicator(
                        activeIndex: pageState.pagerIndex,
                        count: 5,
                        effect: ExpandingDotsEffect(
                            expansionFactor: 2,
                            dotWidth: 15.0,
                            dotHeight: 10.0,
                            activeDotColor: Color(ColorConstants.getPeachDark()),
                            dotColor: Color(ColorConstants.getPrimaryBackgroundGrey())),
                      ),
                    ),
                    pageState.pagerIndex > 0 ? Container(
                      padding: EdgeInsets.only(top: 56, left: 16),
                      alignment: Alignment.topLeft,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: IconButton(
                        onPressed: () {
                          switch(pageState.pagerIndex) {
                            case 1:
                              pageState.setPagerIndex(0);
                              break;
                            case 2:
                              pageState.setPagerIndex(1);
                              break;
                            case 3:
                              pageState.setPagerIndex(0);
                              break;
                            case 4:
                              pageState.setPagerIndex(0);
                              break;
                            case 5:
                              pageState.setPagerIndex(0);
                              break;
                          }
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    ) : SizedBox(),
                  ],
                ),
              ),
            ),
      );
}

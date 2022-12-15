import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/collections_page/CollectionsPageState.dart';
import 'package:dandylight/pages/job_types/JobTypesPage.dart';
import 'package:dandylight/pages/locations_page/LocationsPage.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPage.dart';
import 'package:dandylight/pages/reminders_page/RemindersPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../poses_page/PosesPage.dart';
import '../responses_page/ResponsesPage.dart';

class CollectionsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CollectionsPageState();
  }
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    List<String> collectionIcons = ImageUtil.collectionIcons;
    return StoreConnector<AppState, CollectionsPageState>(
      converter: (store) => CollectionsPageState.fromStore(store),
      builder: (BuildContext context, CollectionsPageState pageState) =>
          Scaffold(
        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              pinned: true,
              centerTitle: true,
              title: Center(
                child: Text(
                  "My Collections",
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'simple',
                    color: const Color(ColorConstants.primary_black),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: new SliverChildListDelegate(
                <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 64.0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              onCollectionSelected(index);
                            },
                            child: Opacity(
                            opacity: 1.0,
                            child:Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(24.0),
                                  height: 116.0,
                                  width: 116.0,
                                  decoration: BoxDecoration(
                                    color: getCircleColor(index),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(collectionIcons.elementAt(index)),
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      ImageUtil.getCollectionIconName(collectionIcons.elementAt(index)),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'simple',
                                        color: const Color(ColorConstants.primary_black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCollectionSelected(int index){
    switch(index){
      case 0:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_COLLECTION_REMINDERS);
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => RemindersPage()),
        );
        break;
      case 1:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_COLLECTION_POSES);
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => PosesPage()),
        );
        break;
      case 2:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_COLLECTION_JOB_TYPES);
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => JobTypesPage()),
        );
        break;
      case 3:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_COLLECTION_PRICE_PACKAGES);
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => PricingProfilesPage()),
        );
        break;
      case 4:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_COLLECTION_LOCATIONS);
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => LocationsPage()),
        );
        break;
      case 5:
        EventSender().sendEvent(eventName: EventNames.NAV_TO_COLLECTION_RESPONSES);
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => ResponsesPage()),
        );
        break;
      case 6:
        DandyToastUtil.showToast("Coming soon! \nThis feature is not ready yet.", Color(ColorConstants.getPeachLight()));
        EventSender().sendEvent(eventName: EventNames.NAV_TO_CONTRACTS);
        break;
      case 7:
        DandyToastUtil.showToast("Coming soon! \nThis feature is not ready yet.", Color(ColorConstants.getPeachDark()));
        EventSender().sendEvent(eventName: EventNames.NAV_TO_AUTOMATED_BOOKING);
        break;
      case 8:
        DandyToastUtil.showToast("Coming soon! \nThis feature is not ready yet.", Color(ColorConstants.getPrimaryColor()));
        EventSender().sendEvent(eventName: EventNames.NAV_TO_QUESTIONNAIRES);
        break;
      case 9:
        DandyToastUtil.showToast("Coming soon! \nThis feature is not ready yet.", Color(ColorConstants.getBlueDark()));
        EventSender().sendEvent(eventName: EventNames.NAV_TO_CLIENT_GUIDES);
        break;
    }
  }

  Color getCircleColor(int index) {
    Color color = Color(ColorConstants.getPeachDark());
    switch(index) {
      case 0:
        color = Color(ColorConstants.getBlueLight());
        break;
      case 1:
        color = Color(ColorConstants.getPeachLight());
        break;
      case 2:
        color = Color(ColorConstants.getPeachDark());
        break;
      case 3:
        color = Color(ColorConstants.getPrimaryColor());
        break;
      case 4:
        color = Color(ColorConstants.getBlueDark());
        break;
      case 5:
        color = Color(ColorConstants.getBlueLight());
        break;
      case 6:
        color = Color(ColorConstants.getPeachLight());
        break;
      case 7:
        color = Color(ColorConstants.getPeachDark());
        break;
      case 8:
        color = Color(ColorConstants.getPrimaryColor());
        break;
      case 9:
        color = Color(ColorConstants.getBlueDark());
        break;
    }
    return color;
  }
}

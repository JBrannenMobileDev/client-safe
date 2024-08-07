import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/collections_page/CollectionsPageState.dart';
import 'package:dandylight/pages/locations_page/LocationsPage.dart';
import 'package:dandylight/pages/questionnaires_page/QuestionnairesPage.dart';
import 'package:dandylight/pages/reminders_page/RemindersPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../utils/DeviceType.dart';
import '../../widgets/TextDandyLight.dart';
import '../contracts_page/ContractsPage.dart';
import '../poses_page/PosesPage.dart';
import '../responses_page/ResponsesPage.dart';
import '../session_types/SessionTypesPage.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({Key? key}) : super(key: key);


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
              automaticallyImplyLeading: false,
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              pinned: true,
              centerTitle: true,
              surfaceTintColor: Colors.transparent,
              title: Center(
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: "My Collections",
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ), systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 64.0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 9,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: DeviceType.getDeviceType() == Type.Tablet ? 4 : 2,
                            childAspectRatio: (DeviceType.getDeviceType() == Type.Tablet ? 150 : 112) / (DeviceType.getDeviceType() == Type.Tablet ? 150 : 124),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              onCollectionSelected(index);
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 24),
                                  height: DeviceType.getDeviceType() == Type.Tablet ? 150 : 112.0,
                                  width: DeviceType.getDeviceType() == Type.Tablet ? 150 : 112.0,
                                  decoration: BoxDecoration(
                                    color: getCircleColor(index),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(collectionIcons.elementAt(index), color: Color(index > 6 ? ColorConstants.getBlueLight() : ColorConstants.getPrimaryWhite()),),
                                ),
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: ImageUtil.getCollectionIconName(collectionIcons.elementAt(index)),
                                      textAlign: TextAlign.center,
                                      color: Color(index > 6 ? ColorConstants.getBlueLight() : ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                ),
                              ],
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
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ContractsPage()),
        );
        break;
      case 1:Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PosesPage(null, false, false, false)),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const QuestionnairesPage(addToJobNew: false)),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SessionTypesPage()),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LocationsPage()),
        );
        break;
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ResponsesPage()),
        );
        break;
      case 6:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RemindersPage()),
        );
        break;
      case 7:
        DandyToastUtil.showToast("Coming 2024! \nThis feature is not ready yet.", Color(ColorConstants.getPrimaryGreyMedium()));
        break;
      case 8:
        DandyToastUtil.showToast("Coming 2024! \nThis feature is not ready yet.", Color(ColorConstants.getPrimaryGreyMedium()));
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
        color = Color(ColorConstants.getPeachMedium());
        break;
      case 2:
        color = Color(ColorConstants.getPeachDark());
        break;
      case 3:
        color = Color(ColorConstants.getBlueLight());
        break;
      case 4:
        color = Color(ColorConstants.getPeachMedium());
        break;
      case 5:
        color = Color(ColorConstants.getPeachDark());
        break;
      case 6:
        color = Color(ColorConstants.getBlueLight());
        break;
      case 7:
        // color = Color(ColorConstants.getPeachDark());
        color = Color(ColorConstants.getBlueLight()).withOpacity(0.5);
        break;
      case 8:
        // color = Color(ColorConstants.getBlueLight());
        color = Color(ColorConstants.getBlueLight()).withOpacity(0.5);
        break;
    }
    return color;
  }
}

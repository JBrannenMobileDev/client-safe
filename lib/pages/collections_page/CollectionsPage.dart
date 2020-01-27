import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/collections_page/CollectionsPageState.dart';
import 'package:client_safe/pages/locations_page/LocationsPage.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
                    fontFamily: 'Raleway',
                    color: const Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Color(ColorConstants.getPrimaryColor()),
                  tooltip: 'Add',
                  onPressed: () {
                    UserOptionsUtil.showCollectionOptionsSheet(context);
                  },
                ),
              ],
            ),
            SliverList(
              delegate: new SliverChildListDelegate(
                <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              onCollectionSelected(index);
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 116.0,
                                  width: 116.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(collectionIcons.elementAt(index)),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 4.0, bottom: 16.0),
                                    child: Text(
                                      ImageUtil.getCollectionIconName(collectionIcons.elementAt(index)),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Raleway',
                                        color: const Color(ColorConstants.primary_black),
                                      ),
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
          new MaterialPageRoute(builder: (context) => PricingProfilesPage()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => LocationsPage()),
        );
        break;
      case 2:

        break;
      case 3:

        break;
    }
  }
}

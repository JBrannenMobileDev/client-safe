import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'BookingPageState.dart';

class BookingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClientDetailsPage();
  }
}

class _ClientDetailsPage extends State<BookingPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BookingPageState>(
      converter: (store) => BookingPageState.fromStore(store),
      builder: (BuildContext context, BookingPageState pageState) =>
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                  expandedHeight: 242.0,
                  pinned: false,
                  floating: false,
                  surfaceTintColor: Colors.transparent,
                  centerTitle: true,
                  title: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'My Bookings',
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pageState.onEditClientClicked!(pageState.client!);
                        NavigationUtil.showNewContactPage(context, pageState.client);
                        EventSender().sendEvent(eventName: EventNames.BT_ADD_NEW_CONTACT, properties: {EventNames.CONTACT_PARAM_COMING_FROM : "Client Details Page - Edit"});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 24.0),
                        height: 24.0,
                        width: 24.0,
                        child: Image.asset(
                            'assets/images/icons/edit_icon_peach.png'),
                      ),
                    ),
                  ],
                  // leading: IconButton(
                  //   icon: const Icon(Icons.close),
                  //   color: Color(ColorConstants.getPrimaryBlack()),
                  //   tooltip: 'Close',
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      padding: const EdgeInsets.only(top: 124, left: 16, right: 16),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(0),
                              bottom: Radius.circular(16)),
                          color: Color(ColorConstants.getPrimaryWhite())
                      ),
                      // child: (pageState.setupComplete ?? false) ? infoContainer(pageState) : setupContainer(),
                      child: infoContainer(pageState),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget setupContainer() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 42, right: 42, bottom: 24, top: 16),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            textAlign: TextAlign.center,
            text: 'Lets get started by setting up your booking page!',
          ),
        ),
        GestureDetector(
          onTap: () {

          },
          child: Container(
            alignment: Alignment.center,
            height: 54,
            width: 232,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(ColorConstants.getPrimaryGreyDark())
            ),
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              textAlign: TextAlign.center,
              text: 'Setup Booking',
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
          ),
        )
      ],
    );
  }

  Widget infoContainer(BookingPageState pageState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 24,
          margin: const EdgeInsets.only(left: 8),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            textAlign: TextAlign.start,
            text: 'Booking Link',
          ),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: MediaQuery.of(context).size.width-68,
              child: TextDandyLight(
                type: TextDandyLight.SMALL_TEXT,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                color: Color(ColorConstants.getPrimaryGreyDark()),
                text: 'dandylight.com/booking/VintageVibesPhotography/23rdf23',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 4),
              child: Icon(Icons.copy, color: Color(ColorConstants.getPrimaryGreyDark())),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 24,
          margin: const EdgeInsets.only(top: 24, left: 8),
          child: TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            textAlign: TextAlign.start,
            text: 'Availability this week',
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 64,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5)
          ),
          child: Row(
            children: [
              dayItem('Mon', 0, false),
              divider(),
              dayItem('Tue', 1, false),
              divider(),
              dayItem('Wed', 2, false),
              divider(),
              dayItem('Thu', 3, true),
              divider(),
              dayItem('Fri', 4, true),
              divider(),
              dayItem('Sat', 5, true),
              divider(),
              dayItem('Sun', 6, false),
            ],
          ),
        )
      ],
    );
  }

  Widget divider() {
    return Container(
      height: 48,
      width: 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
      ),
    );
  }

  Widget dayItem(String dayName, int index, bool isAvailable) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              textAlign: TextAlign.start,
              text: dayName,
            ),
          ),
          isAvailable ? Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(ColorConstants.getPrimaryGreyDark()),
            ),
          ) : const SizedBox()
        ],
      ),
    );
  }
}

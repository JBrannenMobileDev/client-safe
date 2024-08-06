import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'BookingPageActions.dart';
import 'BookingPageState.dart';

class BookingSetupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClientDetailsPage();
  }
}

class _ClientDetailsPage extends State<BookingSetupPage>{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BookingPageState>(
      onInit: (store) {
        store.dispatch(InitializeStateAction(store.state.bookingPageState));
      },
      converter: (store) => BookingPageState.fromStore(store),
      builder: (BuildContext context, BookingPageState pageState) =>
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                  surfaceTintColor: Colors.transparent,
                  centerTitle: true,
                  title: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Booking Setup',
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Booking Link',
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 24, right: 24),
                        child: TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: 'This is a link to your personalized booking web page. Place this link on your website or social media bio to provide a professional booking experience for your clients.',
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8, bottom: 8),
                        child: GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(text: pageState.bookingLink ?? ''));
                            DandyToastUtil.showToast('Copied!', Color(ColorConstants.getPeachDark()));
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 0),
                                width: MediaQuery.of(context).size.width-92,
                                child: TextDandyLight(
                                  type: TextDandyLight.SMALL_TEXT,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  color: Color(ColorConstants.getPrimaryGreyDark()),
                                  text: pageState.bookingLink,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 4),
                                child: Icon(Icons.copy, color: Color(ColorConstants.getPrimaryGreyDark())),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 24),
                            alignment: Alignment.center,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'My Offerings',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 24),
                            child: GestureDetector(
                              onTap: () {
                                NavigationUtil.showNewOfferingPage(context);
                              },
                              child: Icon(Icons.add, color: Color(ColorConstants.getPrimaryBlack())),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 32, left: 32, right: 32),
                        alignment: Alignment.center,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Select the + button to create your first offering.',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
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
        GestureDetector(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: pageState.bookingLink ?? ''));
            DandyToastUtil.showToast('Copied!', Color(ColorConstants.getPeachDark()));
          },
          child: Row(
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
                  text: pageState.bookingLink,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: Icon(Icons.copy, color: Color(ColorConstants.getPrimaryGreyDark())),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 24),
          height: 54,
          width: 224,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: 'Update Availability',
            color: Color(ColorConstants.getPrimaryWhite()),
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

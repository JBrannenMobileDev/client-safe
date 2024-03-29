
import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/sunset_weather_page/ChooseFromMyLocations.dart';
import 'package:dandylight/pages/sunset_weather_page/SelectLocationOptionsDialog.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class SelectLocationDialog extends StatefulWidget {
  @override
  _SelectLocationDialogState createState() {
    return _SelectLocationDialogState();
  }
}

class _SelectLocationDialogState extends State<SelectLocationDialog> {
  final int pageCount = 2;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      currentPageIndex = controller.page!.toInt();
    });
    return StoreConnector<AppState, SunsetWeatherPageState>(
      converter: (store) => SunsetWeatherPageState.fromStore(store),
      builder: (BuildContext context, SunsetWeatherPageState pageState) =>
          Dialog(
            insetPadding: EdgeInsets.only(left: 16.0, right: 16.0),
                backgroundColor: Colors.transparent,
                child: Container(

                  padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
                  decoration: new BoxDecoration(
                      color: Color(ColorConstants.white),
                      borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                            text: "Select a Location",
                            textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        height: 225.0,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller,
                          pageSnapping: true,
                          children: <Widget>[
                            SelectLocationOptionsDialog(),
                            ChooseFromMyLocations(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 26.0, right: 26.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              style: Styles.getButtonStyle(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                textColor: Color(ColorConstants.getPrimaryBlack()),
                                left: 8.0,
                                top: 8.0,
                                right: 8.0,
                                bottom: 8.0,
                              ),
                              // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                              // disabledTextColor:
                              // Color(ColorConstants.primary_bg_grey),
                              // splashColor: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                onBackPressed(pageState);
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Cancel',
                                textAlign: TextAlign.start,
                                color: Color(ColorConstants.getPrimaryBlack()),
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
  }

  void onNextPressed(SunsetWeatherPageState pageState) {
    if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);

    bool canProgress = false;

    switch(pageState.pageViewIndex){
      case 0:
        canProgress = pageState.locationName!.isNotEmpty;
        break;
      case 1:
        canProgress = true;
        break;
      case 2:
        canProgress = false;
        break;
    }
    if (canProgress) {
      pageState.onNextPressed!();
      controller.animateToPage(currentPageIndex + 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
      FocusScope.of(context).unfocus();
    }

    if (pageState.pageViewIndex == pageCount) {
      showSuccessAnimation();
      pageState.onSaveLocationSelected!();
    }
  }

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  void onBackPressed(SunsetWeatherPageState pageState) {
    if (pageState.pageViewIndex == 0) {
      Navigator.of(context).pop();
    } else {
      pageState.onBackPressed!();
      controller.animateToPage(currentPageIndex - 1, duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }
}

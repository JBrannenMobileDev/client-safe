import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DateAndTimeForm extends StatefulWidget {
  @override
  _DateAndTimeFormState createState() {
    return _DateAndTimeFormState();
  }
}

class _DateAndTimeFormState extends State<DateAndTimeForm>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Select a date and time for this job.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
                Container(
                  height: 56.0,
                  width: 56.0,
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/calendar.png"),
                    ),
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Text(
                  "Jan 15, 2020",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Container(
                  height: 56.0,
                  width: 56.0,
                  margin: EdgeInsets.only(top: 32.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/clock.png"),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 64.0, right: 64.0),
                  child: Text(
                    "Sunset is at 4:43 PM",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w800,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),

          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

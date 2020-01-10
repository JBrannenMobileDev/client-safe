import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class TimeSelectionForm extends StatefulWidget {
  @override
  _TimeSelectionFormState createState() {
    return _TimeSelectionFormState();
  }
}

class _TimeSelectionFormState extends State<TimeSelectionForm>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{
  AnimationController _controller;
  AnimationController _repeatController;
  AnimationController _translationController;
  Animation<Offset> _offsetFloat;
  Animation<double> _circleOpacity;
  Animation<double> _circleSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _repeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _translationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _circleOpacity = Tween<double>(begin: 0.25, end: 0.0).animate(CurvedAnimation(
      parent: _repeatController,
      curve: Curves.fastOutSlowIn,
    ));
    _circleSize = Tween<double>(begin: 42.0, end: 80.0)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _circleSize.addListener(() => this.setState(() {}));
    _offsetFloat = Tween<Offset>(begin: Offset(10, 0.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(
      parent: _translationController,
      curve: Curves.decelerate,
    ));


    _controller.repeat();
    _repeatController.repeat();
    _translationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.dispatch(FetchTimeOfSunsetAction(store.state.newJobPageState));
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "Select a time for this job.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 6.0),
              child: Text(
                "Sunset is at " +
                    (pageState.sunsetDateTime != null
                        ? DateFormat('h:mm a').format(pageState.sunsetDateTime)
                        : ""),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                DateFormat('h:mm a').format(pageState.selectedTime),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w800,
                  color: Color(ColorConstants.primary),
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime time) {
                  vibrate();
                  _onConfirmedTime(time, pageState);
                },
                use24hFormat: false,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }

  void _onConfirmedTime(DateTime time, NewJobPageState pageState) {
    pageState.onTimeSelected(time);
  }

  @override
  bool get wantKeepAlive => true;
}

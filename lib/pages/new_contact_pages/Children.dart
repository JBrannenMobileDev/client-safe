import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Children extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ChildrenState();
  }
}

class _ChildrenState extends State<Children> {

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewContactPageState>(
        converter: (store) => NewContactPageState.fromStore(store),
        builder: (BuildContext context, NewContactPageState pageState) =>
            Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              pageState.numberOfChildren.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 68.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
                color: Color(ColorConstants.primary_black),
              ),
            ),
            Text(
              "How many children does " +
                  pageState.newContactFirstName +
                  " have?",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
                color: Color(ColorConstants.primary_black),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              width: 250.0,
              child: CupertinoSlider(
                value: pageState.numberOfChildren.toDouble(),
                min: 0.0,
                max: 10.0,
                divisions: 10,
                onChanged: (double numOfChildren) {
                  vibrate();
                  pageState.onNumberOfChildrenChanged(numOfChildren.toInt());
                },
              ),
            ),
          ],
        ),
      );

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }
}

import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class Children extends StatefulWidget{
  final NewContactPageState pageState;

  Children(this.pageState);

  @override
  State<StatefulWidget> createState() {
    return _ChildrenState(pageState);
  }
}

class _ChildrenState extends State<Children>{
  final NewContactPageState pageState;
  int _numOfChildren = 0;

  _ChildrenState(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          _numOfChildren.toString(),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 64.0,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w600,
            color: Color(ColorConstants.primary_black),
          ),
        ),
        Text(
          "How many children does " + pageState.newContactFirstName + " have?",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w600,
            color: Color(ColorConstants.primary_black),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16.0),
          width: 250.0,
          child: CupertinoSlider(
            value: _numOfChildren.toDouble(),
            min: 0.0,
            max: 10.0,
            divisions: 10,
            onChanged: (double numOfChildren) {
              setState(() {
                _numOfChildren = numOfChildren.toInt();
                pageState.onNumberOfChildrenChanged(numOfChildren.toInt());
              });
            },
          ),
        ),
      ],
    );
  }
}
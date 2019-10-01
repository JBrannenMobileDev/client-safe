import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class Children extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ChildrenState();
  }
}

class _ChildrenState extends State<Children>{
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          _value.toString(),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 64.0,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w600,
            color: Color(ColorConstants.primary_black),
          ),
        ),
        Text(
          "How many children does Client have?",
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
            value: _value,
            min: 0.0,
            max: 10.0,
            divisions: 10,
            onChanged: (double value) {
              setState(() {
                _value = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
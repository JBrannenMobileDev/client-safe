import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class SearchButtonsRow extends StatelessWidget {
  SearchButtonsRow(this.letter1, this.letter2, this.letter3, this.letter4,
      this.letter5, this.letter6, this.letter7);

  final String letter1;
  final String letter2;
  final String letter3;
  final String letter4;
  final String letter5;
  final String letter6;
  final String letter7;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FlatButton(
              splashColor: const Color(ColorConstants.primary_dark),
              onPressed: _onLetter1Pressed,
              child: Text(
                letter1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              splashColor: const Color(ColorConstants.primary_dark),
              onPressed: _onLetter2Pressed,
              child: Text(
                letter2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              splashColor: const Color(ColorConstants.primary_dark),
              onPressed: _onLetter3Pressed,
              child: Text(
                letter3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              splashColor: const Color(ColorConstants.primary_dark),
              onPressed: _onLetter4Pressed,
              child: Text(
                letter4,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              splashColor: const Color(ColorConstants.primary_dark),
              onPressed: _onLetter5Pressed,
              child: Text(
                letter5,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              splashColor: const Color(ColorConstants.primary_dark),
              onPressed: _onLetter6Pressed,
              child: Text(
                letter6,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              splashColor: const Color(ColorConstants.primary_dark),
              onPressed: _onLetter7Pressed,
              child: Text(
                letter7,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onLetter1Pressed() {}

  _onLetter2Pressed() {}

  _onLetter3Pressed() {}

  _onLetter4Pressed() {}

  _onLetter5Pressed() {}

  _onLetter6Pressed() {}

  _onLetter7Pressed() {}
}

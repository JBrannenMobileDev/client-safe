import 'package:client_safe/pages/clients_page/widgets/SearchButtonsRow.dart';
import 'package:flutter/material.dart';

class ClientSearchButtons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SearchButtonsRow("A", "B", "C", "D", "E", "F", "G"),
          SearchButtonsRow("H", "I", "J", "K", "L", "M", "N"),
          SearchButtonsRow("O", "P", "Q", "R", "S", "T", "U"),
          SearchButtonsRow(" ", "V", "W", "X", "Y", "Z", " "),
        ],
      ),
    );
  }

}
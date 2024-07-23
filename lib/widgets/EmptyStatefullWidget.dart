import 'package:dandylight/AppState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EmptyStatefulWidget extends StatefulWidget {
  const EmptyStatefulWidget({super.key});

  @override
  EmptyWidget createState() {
    return EmptyWidget();
  }
}

class EmptyWidget extends State<EmptyStatefulWidget> {

  @override
  Widget build(BuildContext context) {
    // return StoreConnector<AppState, GenericPageState>(
    //   converter: (store) => GenericPageState.fromStore(store),
    //   builder: (BuildContext context, GenericPageState pageState) =>
    //   const SizedBox(),
    // );
    return const SizedBox(); //Delete this
  }
}
import 'package:dandylight/widgets/BottomSheet.dart';
import 'package:flutter/cupertino.dart';

class EmptyBottomSheet extends StatelessWidget {
  const EmptyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      body: Body(),
      showPlusIcon: false,
      title: 'Dialog Title',
      dialogHeight: MediaQuery.of(context).size.height-64,
      showDoneButton: false,
    );
  }
}

class Body extends StatefulWidget {
  @override
  _body createState() {
    return _body();
  }
}

class _body extends State<Body> {

  @override
  Widget build(BuildContext context) {
    // return StoreConnector<AppState, NewJobPageState>(
    //     converter: (store) => NewJobPageState.fromStore(store),
    //     builder: (BuildContext context, NewJobPageState pageState) => ClientSelectionForm()
    // );

    return const SizedBox(); //Delete this
  }
}
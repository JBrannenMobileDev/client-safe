import 'package:dandylight/AppState.dart';
import 'package:redux/redux.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CollectionsPageState {


  CollectionsPageState(

  );

  factory CollectionsPageState.initial() => CollectionsPageState();

  factory CollectionsPageState.fromStore(Store<AppState> store) {
    return CollectionsPageState(

    );
  }
}

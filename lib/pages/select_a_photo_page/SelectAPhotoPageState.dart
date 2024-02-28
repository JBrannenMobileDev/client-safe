import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class SelectAPhotoPageState{
  final List<String> urls;

  SelectAPhotoPageState({
    @required this.urls,
  });

  SelectAPhotoPageState copyWith({
    List<String> urls,
  }){
    return SelectAPhotoPageState(
      urls: urls ?? this.urls,
    );
  }

  factory SelectAPhotoPageState.initial() => SelectAPhotoPageState(
    urls: [],
  );

  factory SelectAPhotoPageState.fromStore(Store<AppState> store) {
    return SelectAPhotoPageState(
      urls: store.state.selectAPhotoPageState.urls,
    );
  }

  @override
  int get hashCode =>
      urls.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SelectAPhotoPageState &&
              urls == other.urls;
}
import 'package:client_safe/pages/home_page/HomePageState.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final HomePageState homePageState;
  AppState(this.homePageState);

  factory AppState.initial() {
    return AppState(HomePageState.initial());
  }
}
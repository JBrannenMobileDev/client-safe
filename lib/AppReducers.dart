import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/home_page/HomePageReducer.dart';

AppState appReducers(AppState state, action) {
  final homeReducer = homePageReducer(state.homePageState, action);
  return new AppState(homeReducer);
}

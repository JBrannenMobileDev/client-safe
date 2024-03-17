import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/pages/locations_page/LocationsActions.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:share_plus/share_plus.dart';


class LocationsPageMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchLocationsAction) {
      fetchLocations(store, next);
    }
    if (action is DrivingDirectionsSelected) {
      _launchDrivingDirections(store, action);
    }
    if (action is ShareLocationSelected) {
      _shareDirections(store, action);
    }
  }

  void _launchDrivingDirections(Store<AppState> store, DrivingDirectionsSelected action) async {
    IntentLauncherUtil.launchDrivingDirections(
        action.location!.latitude.toString(),
        action.location!.longitude.toString());
  }

  void _shareDirections(Store<AppState> store, ShareLocationSelected action) {
    Share.share(
        'Here are the driving directions. \nLocation: ${action.location!.locationName}\n\nhttps://www.google.com/maps/search/?api=1&query=${action.location!.latitude},${action.location!.longitude}');
  }

  void fetchLocations(Store<AppState> store, NextDispatcher next) async {
   (await LocationDao.getLocationsStream()).listen((snapshots) async {
      List<LocationDandy> streamLocations = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        streamLocations.add(LocationDandy.fromMap(clientSnapshot.value! as Map<String,dynamic>));
      }
      store.dispatch(SetLocationsAction(store.state.locationsPageState, streamLocations));
    });
  }
}

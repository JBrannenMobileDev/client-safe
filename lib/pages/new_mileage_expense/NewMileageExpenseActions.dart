import 'dart:io';

import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoadExistingPricingProfileData{
  final NewMileageExpensePageState pageState;
  final SingleExpense mileageExpense;
  LoadExistingPricingProfileData(this.pageState, this.mileageExpense);
}

class SaveMileageExpenseProfileAction{
  final NewMileageExpensePageState pageState;
  SaveMileageExpenseProfileAction(this.pageState);
}

class ClearMileageExpenseStateAction{
  final NewMileageExpensePageState pageState;
  ClearMileageExpenseStateAction(this.pageState);
}

class DeleteMileageExpenseAction{
  final NewMileageExpensePageState pageState;
  DeleteMileageExpenseAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewMileageExpensePageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewMileageExpensePageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class SetExpenseDateAction{
  final NewMileageExpensePageState pageState;
  final DateTime expenseDate;
  SetExpenseDateAction(this.pageState, this.expenseDate);
}

class LoadExistingMileageExpenseAction{
  final NewMileageExpensePageState pageState;
  final MileageExpense mileageExpense;
  LoadExistingMileageExpenseAction(this.pageState, this.mileageExpense);
}

class UpdateStartLocationAction{
  final NewMileageExpensePageState pageState;
  final LatLng startLocation;
  UpdateStartLocationAction(this.pageState, this.startLocation);
}

class SaveHomeLocationAction{
  final NewMileageExpensePageState pageState;
  final LatLng startLocation;
  SaveHomeLocationAction(this.pageState, this.startLocation);
}

class UpdateEndLocationAction{
  final NewMileageExpensePageState pageState;
  final LatLng endLocation;
  UpdateEndLocationAction(this.pageState, this.endLocation);
}

class SetLocationNameAction{
  final NewMileageExpensePageState pageState;
  final String selectedLocationName;
  SetLocationNameAction(this.pageState, this.selectedLocationName);
}

class FetchLastKnowPosition{
  final NewMileageExpensePageState pageState;
  FetchLastKnowPosition(this.pageState);
}

class SetInitialMapLatLng{
  final NewMileageExpensePageState pageState;
  final double lat;
  final double lng;
  SetInitialMapLatLng(this.pageState, this.lat, this.lng);
}

class SetProfileData{
  final NewMileageExpensePageState pageState;
  final Profile profile;
  SetProfileData(this.pageState, this.profile);
}

class SetEndLocationNameAction{
  final NewMileageExpensePageState pageState;
  final String endLocationName;
  final LatLng endLocation;
  SetEndLocationNameAction(this.pageState, this.endLocation, this.endLocationName);
}

class SetStartLocationNameAction{
  final NewMileageExpensePageState pageState;
  final String startLocationName;
  final LatLng startLocation;
  SetStartLocationNameAction(this.pageState, this.startLocation, this.startLocationName);
}

class SetMilesDrivenAction{
  final NewMileageExpensePageState pageState;
  final double milesDriven;
  SetMilesDrivenAction(this.pageState, this.milesDriven);
}

class SetSelectedFilterAction{
  final NewMileageExpensePageState pageState;
  final String selectedFilter;
  SetSelectedFilterAction(this.pageState, this.selectedFilter);
}

class SetSelectedLocationAction{
  final NewMileageExpensePageState pageState;
  final Location selectedLocation;
  SetSelectedLocationAction(this.pageState, this.selectedLocation);
}

class SetMileageLocationsAction{
  final NewMileageExpensePageState pageState;
  final List<Location> locations;
  final List<File> imageFiles;
  SetMileageLocationsAction(this.pageState, this.locations, this.imageFiles);
}

class MileageDocumentPathAction{
  final NewMileageExpensePageState pageState;
  final String documentPath;
  MileageDocumentPathAction(this.pageState, this.documentPath);
}

class SetExistingMileageExpenseAction{
  final NewMileageExpensePageState pageState;
  final MileageExpense expense;
  SetExistingMileageExpenseAction(this.pageState, this.expense);
}

class LoadNewMileageLocationsAction{
  final NewMileageExpensePageState pageState;
  LoadNewMileageLocationsAction(this.pageState);
}





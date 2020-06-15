import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/MileageExpense.dart';
import 'package:client_safe/models/PlacesLocation.dart';
import 'package:client_safe/models/Profile.dart';
import 'package:client_safe/models/SingleExpense.dart';
import 'package:client_safe/pages/new_mileage_expense/NewMileageExpensePageState.dart';
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

class UpdateCostAction{
  final NewMileageExpensePageState pageState;
  final String newCost;
  UpdateCostAction(this.pageState, this.newCost);
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

class SaveHomeLocationAction{
  final NewMileageExpensePageState pageState;
  final LatLng homeLocation;
  SaveHomeLocationAction(this.pageState, this.homeLocation);
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







import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageMiddleware.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPageMiddleware.dart';
import 'package:client_safe/pages/locations_page/LocationsActions.dart';
import 'package:client_safe/pages/locations_page/LocationsPageMiddleware.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageMiddleware.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageMiddleware.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart' as prefix2;
import 'package:client_safe/pages/new_location_page/NewLocationPageMiddleware.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart' as prefix0;
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageMiddleware.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesActions.dart' as prefix1;
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageMiddleware.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware() {
  List<Middleware<AppState>> middlewareList = new List<Middleware<AppState>>();
  middlewareList.add(TypedMiddleware<AppState, FetchClientData>(ClientsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewContactAction>(NewContactPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, InitializeClientDetailsAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteClientAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, InstagramSelectedAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchAllClientsAction>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SavePricingProfileAction>(NewPricingProfilePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchPricingProfilesAction>(PricingProfilesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix0.DeletePriceProfileAction>(NewPricingProfilePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix1.DeletePriceProfileAction>(PricingProfilesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteLocationAction>(LocationsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchLocationsAction>(LocationsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix2.FetchLocationsAction>(NewLocationPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix2.SaveLocationAction>(LocationsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix2.ClearStateAction>(NewLocationPageMiddleware()));
  return middlewareList;
}



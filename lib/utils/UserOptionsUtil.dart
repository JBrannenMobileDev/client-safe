
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/IncomeAndExpenses/AddTipDialog.dart';
import 'package:dandylight/pages/IncomeAndExpenses/ViewInvoiceDialog.dart';
import 'package:dandylight/pages/job_details_page/DepositChangeDialog.dart';
import 'package:dandylight/pages/job_details_page/JobTypeChangeDialog.dart.dart';
import 'package:dandylight/pages/job_details_page/LocationSelectionDialog.dart';
import 'package:dandylight/pages/job_details_page/NameChangeDialog.dart';
import 'package:dandylight/pages/job_details_page/NewDateSelectionDialog.dart';
import 'package:dandylight/pages/job_details_page/PricePackageChangeDialog.dart.dart';
import 'package:dandylight/pages/job_details_page/TipChangeDialog.dart';
import 'package:dandylight/pages/job_details_page/document_items/InvoiceOptionsDialog.dart';
import 'package:dandylight/pages/login_page/ShowAccountCreatedDialog.dart';
import 'package:dandylight/pages/new_contact_pages/DeviceContactsPage.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPage.dart';
import 'package:dandylight/pages/new_contact_pages/StartJobPromptDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoiceDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewLineItemDialog.dart';
import 'package:dandylight/pages/new_invoice_page/SendInvoicePromptDialog.dart';
import 'package:dandylight/pages/new_job_page/NewJobPage.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPage.dart';
import 'package:dandylight/pages/new_mileage_expense/ChooseFromMyLocationsMileage.dart';
import 'package:dandylight/pages/new_mileage_expense/LocationOptionsMileageExpenseDialog.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePage.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePage.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePage.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePage.dart';
import 'package:dandylight/pages/sunset_weather_page/ChooseFromMyLocations.dart';
import 'package:dandylight/pages/sunset_weather_page/SelectLocationDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import 'ColorConstants.dart';

class UserOptionsUtil {

  static void showNewContactDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewContactPage();
      },
    );
  }

  static void showMileageLocationSelectionDialog(BuildContext context, Function(LatLng) onLocationSaved, double lat, double lng) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocationOptionsMileageExpenseDialog(onLocationSaved, lat, lng);
      },
    );
  }

  static void showNewPriceProfileDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewPricingProfilePage();
      },
    );
  }

  static void showNewMileageExpenseSelected(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewMileageExpensePage();
      },
    );
  }

  static void showNewJobDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewJobPage();
      },
    );
  }

  static void showSelectLocationDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectLocationDialog();
      },
    );
  }

  static void showChooseFromMyLocationsDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChooseFromMyLocations();
      },
    );
  }

  static void showChooseFromMyLocationsMileageDialog(BuildContext context, Function(LatLng) onLocationSaved){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChooseFromMyLocationsMileage(onLocationSaved);
      },
    );
  }

  static void showNewLocationDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewLocationPage();
      },
    );
  }

  static void showDeviceContactsDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeviceContactsPage();
      },
    );
  }

  static void showDateSelectionCalendarDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewDateSelectionDialog();
      },
    );
  }

  static void showLocationSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocationSelectionDialog();
      },
    );
  }

  static void showNameChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NameChangeDialog();
      },
    );
  }

  static void showJobPromptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StartJobPromptDialog();
      },
    );
  }

  static void showSendInvoicePromptDialog(BuildContext context, int invoiceId, Function onSendInvoiceSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SendInvoicePromptDialog(invoiceId, onSendInvoiceSelected);
      },
    );
  }

  static void showAccountCreatedDialog(BuildContext context, FirebaseUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowAccountCreatedDialog(user);
      },
    );
  }

  static void showDepositChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DepositChangeDialog();
      },
    );
  }

  static void showTipChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TipChangeDialog();
      },
    );
  }

  static void showJobTypeChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return JobTypeChangeDialog();
      },
    );
  }

  static void showPricePackageChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PricePackageChangeDialog();
      },
    );
  }

  static void showNewSingleExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewSingleExpensePage();
      },
    );
  }

  static void showNewRecurringExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewRecurringExpensePage();
      },
    );
  }

  static void showNewInvoiceDialog(BuildContext context, Function onSendInvoiceSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewInvoiceDialog(onSendInvoiceSelected);
      },
    );
  }

  static void showAddTipDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTipDialog();
      },
    );
  }

  static void showViewInvoiceDialog(BuildContext context, Invoice invoice, Job job, Function onSendInvoiceSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ViewInvoiceDialog(invoice, job, onSendInvoiceSelected);
      },
    );
  }

  static void showInvoiceOptionsDialog(BuildContext context, Function onSendInvoiceSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvoiceOptionsDialog(onSendInvoiceSelected);
      },
    );
  }

  static void showNewLineItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewLineItemDialog();
      },
    );
  }

  static void showNewDiscountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewDiscountDialog();
      },
    );
  }

  static void showDashboardOptionsSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 154.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                      Icons.person,
                      color: Color(ColorConstants.getPrimaryBlack())
                  ),
                  title: Text(
                      "Add New Contact",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewContactPage();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.business_center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  title: Text(
                      "Start New Job",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewJobPage();
                      },
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  static void showCollectionOptionsSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 233.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text("New Pricing Profile"),
                  onTap: () {
                    showNewPriceProfileDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("New Photoshoot Location"),
                  onTap: () {
                    showNewLocationDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text("New Contract Template"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text("New Example Pose"),
                  onTap: () {},
                ),
              ],
            ),
          );
        });
  }
}

import 'package:client_safe/pages/job_details_page/DepositChangeDialog.dart';
import 'package:client_safe/pages/job_details_page/JobTypeChangeDialog.dart.dart';
import 'package:client_safe/pages/job_details_page/LocationSelectionDialog.dart';
import 'package:client_safe/pages/job_details_page/NameChangeDialog.dart';
import 'package:client_safe/pages/job_details_page/NewDateSelectionDialog.dart';
import 'package:client_safe/pages/job_details_page/PricePackageChangeDialog.dart.dart';
import 'package:client_safe/pages/new_contact_pages/DeviceContactsPage.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPage.dart';
import 'package:client_safe/pages/new_contact_pages/StartJobPromptDialog.dart';
import 'package:client_safe/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoiceDialog.dart';
import 'package:client_safe/pages/new_invoice_page/NewLineItemDialog.dart';
import 'package:client_safe/pages/new_job_page/NewJobPage.dart';
import 'package:client_safe/pages/new_location_page/NewLocationNamePage.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  static void showNewPriceProfileDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewPricingProfilePage();
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

  static void showNewLocationDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewLocationNamePage();
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

  static void showDepositChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DepositChangeDialog();
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

  static void showNewInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewInvoiceDialog();
      },
    );
  }

  static void showStartJobPromptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewInvoiceDialog();
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

import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPage.dart';
import 'package:client_safe/pages/new_location_page/NewLocationNamePage.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  static void showNewLocationDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewLocationNamePage();
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
            height: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Add New Client"),
                  onTap: () {
                    showNewContactDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Start New Job"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.folder),
                  title: Text("Add to Collection"),
                  onTap: () {},
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
                  onTap: () {},
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

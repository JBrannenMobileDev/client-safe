import 'package:client_safe/pages/new_contact_pages/NewContactPage.dart';
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

  static void showOptionsSheet(BuildContext context) {
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
                  title: Text("Add New Contact"),
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/common_wiget/dialog/show_alert_dialog.dart';
import 'package:my_app/common_wiget/exception_alert_dialog/exception_alert_dialog.dart';
import 'package:my_app/service/auth.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _signOut(BuildContext context) async {
      final auth = Provider.of<AuthBase>(context, listen: false);
      try {
        await auth.signOut();
      } on FirebaseException catch (error) {
        showExceptionAlertDialog(context,
            title: 'Something went wrong', exception: error);
      }
    }

    Future<void> _confirmSignOut(BuildContext context) async {
      final didRequestSignOut = await showAlertDialog(context,
          title: 'Sign out',
          content: 'Are you sure that you want tot sign out?',
          cancelActionText: 'Cancel',
          defaultActionText: 'Ok');

      if (didRequestSignOut) {
        _signOut(context);
      }
    }

    return Scaffold(
        appBar: AppBar(title: Text('Account')),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          ListTile(
            title: Text('Logout'),
            trailing: Icon(Icons.keyboard_arrow_right),
            shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            onTap: () => _confirmSignOut(context),
          )
        ]));
  }
}

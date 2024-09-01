import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/common_wiget/dialog/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) {
  return showAlertDialog(context,
      title: title, content: _message(exception), defaultActionText: 'Ok');
}


String _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message ?? '';
  }

  return exception.toString();
}
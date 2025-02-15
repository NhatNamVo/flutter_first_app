import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
}) {
  if (!Platform.isIOS) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: <Widget>[
                  if (cancelActionText != null)
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(cancelActionText)),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(defaultActionText)),
                ])).then((value) => value ?? false);
  }

  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                if (cancelActionText != null)
                  CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(cancelActionText)),
                CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(defaultActionText)),
              ])).then((value) => value ?? false);
}

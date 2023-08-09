import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:friend_circle/Widgets/multi_platform_widget.dart';

class MultiPlatformAlertDialog extends MultiPlatformWidget {

  final String title;
  final String content;
  final String acceptText;
  final String? declineText;

  MultiPlatformAlertDialog({required this.title, required this.content, required this.acceptText, this.declineText});


  Future<bool?> show(BuildContext context) async {
    if (Platform.isIOS) {
      return await showCupertinoDialog<bool>(
        context: context, builder: (context) => this);
    } else {
      return await showDialog<bool>(
        context: context,
        builder: (context) => this,
        barrierDismissible: false);
    }
  }



  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: dialogButtonSettings(context),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: dialogButtonSettings(context),
    );
  }

  List<Widget> dialogButtonSettings(BuildContext context) {
    final buttons = <Widget>[];

    if (Platform.isIOS) {
      if (declineText != null) {
        buttons.add(
          CupertinoDialogAction(
            child: Text(declineText!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      buttons.add(
        CupertinoDialogAction(
          child: Text(acceptText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (declineText != null) {
        buttons.add(
          ElevatedButton(
            child: Text(declineText!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      buttons.add(
        ElevatedButton(
          child: Text("ok"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    return buttons;
  }

}
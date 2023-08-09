import 'dart:io';

import 'package:flutter/material.dart';

abstract class MultiPlatformWidget extends StatelessWidget {

  Widget buildAndroidWidget(BuildContext context);
  Widget buildIosWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidWidget(context) : buildIosWidget(context);
    
  }
}

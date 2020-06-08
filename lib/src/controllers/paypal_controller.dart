import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/address.dart';
import '../repository/user_repository.dart' as userRepo;

class PayPalController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  String url = "";
  double progress = 0;
  Address deliveryAddress;
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String orderTime = null;

  PayPalController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    super.initState();

    final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';
    final String _userId = 'user_id=${userRepo.currentUser.value.id}';
    final String _orderTime = 'order_time=$orderTime';
    final String _deliveryAddress =
        'delivery_address_id=${userRepo.deliveryAddress?.id}';
    url =
        '${GlobalConfiguration().getString('base_url')}payments/paypal/express-checkout?$_apiToken&$_userId&$_deliveryAddress&$_orderTime';

    flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (state != null) {
        if (state.url ==
            "${GlobalConfiguration().getString('base_url')}payments/paypal")
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 3);
      }
    });

    flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (error != null) {
        // print('onHttpError: ${error.code} ${error.url}');
      }
    });

    flutterWebViewPlugin.onProgressChanged.listen((double progressStatus) {
      if (progress != null) {
        setState(() {
          progress = progressStatus;
        });
      }
    });

    setState(() {});
  }
}

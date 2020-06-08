import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:food_delivery_app/generated/i18n.dart';
import 'package:food_delivery_app/src/controllers/mercado_controller.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/route_argument.dart';

class MercadoPaymentWidget extends StatefulWidget {
  RouteArgument routeArgument;
  MercadoPaymentWidget({Key key, this.routeArgument}) : super(key: key);
  @override
  _MercadoPaymentWidgetState createState() => _MercadoPaymentWidgetState();
}

class _MercadoPaymentWidgetState extends StateMVC<MercadoPaymentWidget> {
  MercadoController _con;
  _MercadoPaymentWidgetState() : super(MercadoController()) {
    _con = controller;
  }

  @override
  void initState() {
    widget.routeArgument.orderTime != null
        ? _con.orderTime = DateFormat('yyyy-MM-dd HH:mm')
            .format(widget.routeArgument.orderTime)
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).mercado_payment,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.autorenew),
            onPressed: () {
              _con.flutterWebViewPlugin.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          WebviewScaffold(
            url: _con.url,
            mediaPlaybackRequiresUserGesture: false,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.blueAccent,
              child: const Center(
                child: Text('Waiting.....'),
              ),
            ),
          ),
          _con.progress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: _con.progress,
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

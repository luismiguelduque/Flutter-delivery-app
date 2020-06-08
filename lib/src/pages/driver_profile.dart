import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/i18n.dart';
import 'package:food_delivery_app/src/elements/ProfileAvatarWidget.dart';

import '../models/route_argument.dart';

class DriverProfileWidget extends StatefulWidget {
  RouteArgument routeArgument;
  DriverProfileWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DriverProfileWidgetState createState() => _DriverProfileWidgetState();
}

class _DriverProfileWidgetState extends State<DriverProfileWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).driver_profile,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileAvatarWidget(user: widget.routeArgument.param),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.person,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).about,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.routeArgument.param?.bio ?? "",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.phone,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).phone,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.routeArgument.param?.phone ?? "",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.email,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).email,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.routeArgument.param?.email ?? "",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

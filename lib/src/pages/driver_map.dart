import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/driver_map_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/route_argument.dart';

class DriverMapWidget extends StatefulWidget {
  RouteArgument routeArgument;

  DriverMapWidget({Key key, this.routeArgument}) : super(key: key);
  @override
  _DriverMapWidgetState createState() => _DriverMapWidgetState();
}

class _DriverMapWidgetState extends StateMVC<DriverMapWidget> {
  DriverMapController _con;

  _DriverMapWidgetState() : super(DriverMapController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.driverId = widget.routeArgument.id;
    _con.orderStatus = widget.routeArgument.param;
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
          _con.orderStatus == null
          ?S.of(context).maps_explorer
          :_con.orderStatus,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              _con.goCurrentLocation();
            },
          )
        ],
      ),
      body: Stack(
//        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          _con.cameraPosition == null
              ? CircularLoadingWidget(height: 0)
              : GoogleMap(
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _con.cameraPosition,
                  markers: Set.from(_con.allMarkers),
                  onMapCreated: (GoogleMapController controller) {
                    _con.mapController.complete(controller);
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    _con.cameraPosition = cameraPosition;
                  },
                  onCameraIdle: () {
                    _con.getRestaurantsOfArea();
                  },
                  polylines: _con.polylines,
                ),
        ],
      ),
    );
  }
}

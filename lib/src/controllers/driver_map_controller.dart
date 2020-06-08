import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/src/controllers/checkout_controller.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../helpers/maps_util.dart';
import '../models/restaurant.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart' as sett;

class DriverMapController extends ControllerMVC {
  String driverId;
  String orderStatus;
  User driver;
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Marker> allMarkers = <Marker>[];
  LocationData currentLocation;
  Set<Polyline> polylines = new Set();
  CameraPosition cameraPosition;
  MapsUtil mapsUtil = new MapsUtil();
  Completer<GoogleMapController> mapController = Completer();
  Map driverMap = Map<String, dynamic>();

  DriverMapController() {
    getCurrentLocation();
    getDirectionSteps();
  }

  void listenForNearRestaurants(
      LocationData myLocation, LocationData areaLocation) async {
    final Stream<Restaurant> stream =
        await getNearRestaurants(myLocation, areaLocation);
    stream.listen((Restaurant _restaurant) {
      setState(() {
        topRestaurants.add(_restaurant);
      });
      Helper.getMarker(_restaurant.toMap()).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    }, onError: (a) {}, onDone: () {});
  }

  void getCurrentLocation() async {
    try {
      currentLocation = await sett.getCurrentLocation();
      Location location = new Location();
      location.changeSettings(distanceFilter: 10.0);
      location.onLocationChanged().listen((loc) async {
        currentLocation = loc;
        Helper.getMyPositionMarker(
                currentLocation.latitude, currentLocation.longitude)
            .then((marker) {
          setState(() {
            int id =
                allMarkers.indexWhere((old) => old.markerId == MarkerId("0"));
            if (id >= 0) allMarkers.removeAt(id);
            allMarkers.add(marker);
          });
        });
        await getDirectionSteps();
      });
      driver = await getUser(driverId);
      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(double.parse(driver.curLatitude),
              double.parse(driver.curLongitude)),
          zoom: 14.4746,
        );
      });
      Helper.getMyPositionMarker(
              currentLocation.latitude, currentLocation.longitude)
          .then((marker) {
        setState(() {
          int id =
              allMarkers.indexWhere((old) => old.markerId == MarkerId("0"));
          if (id >= 0) allMarkers.removeAt(id);
          allMarkers.add(marker);
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14.4746,
    )));
  }

  void getRestaurantsOfArea() async {
    setState(() {
      topRestaurants = <Restaurant>[];
      LocationData areaLocation = LocationData.fromMap({
        "latitude": cameraPosition.target.latitude,
        "longitude": cameraPosition.target.longitude
      });
      if (cameraPosition != null) {
        listenForNearRestaurants(currentLocation, areaLocation);
      } else {
        listenForNearRestaurants(currentLocation, currentLocation);
      }
    });
  }

  void getDirectionSteps() async {
    polylines = new Set();
    getUser(driverId).then((value) => {
          driver = value,
          mapsUtil
              .get("origin=" +
                  currentLocation.latitude.toString() +
                  "," +
                  currentLocation.longitude.toString() +
                  "&destination=" +
                  driver.curLatitude +
                  "," +
                  driver.curLongitude +
                  "&key=${sett.setting.value?.googleMapsKey}")
              .then((dynamic res) async {
            List<LatLng> _latLng = res as List<LatLng>;
            _latLng.insert(
                0,
                new LatLng(
                    currentLocation.latitude, currentLocation.longitude));
            setState(() {
              polylines.add(new Polyline(
                  visible: true,
                  polylineId:
                      new PolylineId(currentLocation.hashCode.toString()),
                  points: _latLng,
                  color: Color(0xFFea5c44),
                  width: 6));
            });

            driverMap['id'] = "-1";
            driverMap['name'] = driver.name + " (driver)";
            driverMap['distance'] =
                await CheckoutController.getDeliveryDistance(
                    currentLocation.latitude.toString(),
                    currentLocation.longitude.toString(),
                    driver.curLatitude,
                    driver.curLongitude);
            driverMap['distance'] /= 1610;
            driverMap['latitude'] = driver.curLatitude;
            driverMap['longitude'] = driver.curLongitude;
            Helper.getMarker(driverMap).then((marker) {
              setState(() {
                int id = allMarkers
                    .indexWhere((old) => old.markerId == MarkerId("-1"));
                if (id >= 0) allMarkers.removeAt(id);
                allMarkers.add(marker);
              });
            });
          })
        });
  }

  Future refreshMap() async {
    setState(() {
      topRestaurants = <Restaurant>[];
    });
    listenForNearRestaurants(currentLocation, currentLocation);
  }
}

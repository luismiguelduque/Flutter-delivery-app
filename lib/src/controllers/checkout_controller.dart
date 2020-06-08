import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../models/credit_card.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../repository/cart_repository.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class CheckoutController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  Payment payment;
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  static double delivery = 0.0;
  CreditCard creditCard = new CreditCard();
  bool loading = true;
  GlobalKey<ScaffoldState> scaffoldKey;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  void listenForCarts(
      {String message, bool withAddOrder = false, DateTime orderTime}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () async {
      await calculateSubtotal();
      if (withAddOrder != null && withAddOrder == true) {
        addOrder(carts, orderTime);
      }
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addOrder(List<Cart> carts, DateTime orderTime) async {
    Order _order = new Order();
    _order.foodOrders = new List<FoodOrder>();
    _order.tax = setting.value.defaultTax;
    _order.orderTime = orderTime;
    _order.deliveryFee = delivery;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = userRepo.deliveryAddress;
    carts.forEach((_cart) {
      FoodOrder _foodOrder = new FoodOrder();
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.getFoodPrice();
      _foodOrder.food = _cart.food;
      _foodOrder.extras = _cart.extras;
      _order.foodOrders.add(_foodOrder);
    });
    orderRepo.addOrder(_order, this.payment).then((value) {
      if (value is Order) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void calculateSubtotal() async {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal += cart.quantity * cart.getFoodPrice();
    });
    taxAmount = subTotal * settingRepo.setting.value.defaultTax / 100;
    deliveryFee = carts[0].food.restaurant.deliveryFee;
    switch (carts[0].food.restaurant.deliveryFeeType) {
      case 1:
        deliveryFee = deliveryFee * subTotal / 100;
        total = subTotal + taxAmount + deliveryFee;
        delivery = deliveryFee;
        setState(() {});
        break;
      case 2:
        getDeliveryDistance(carts[0].food.restaurant.latitude, carts[0].food.restaurant.longitude, userRepo.deliveryAddress.latitude, userRepo.deliveryAddress.longitude).then((value) => {
              deliveryFee = value * deliveryFee * subTotal / 100000,
              total = subTotal + taxAmount + deliveryFee,
              delivery = deliveryFee,
              setState(() {}),
            });
        break;
      default:
        total = subTotal + taxAmount + deliveryFee;
        delivery = deliveryFee;
        setState(() {});
        break;
    }
  }

  static Future<double> getDeliveryDistance(String lat1, String lon1, String lat2, String lon2) async {
    final Distance distance = new Distance();
    final double dis = distance(
        new LatLng(double.parse(lat1), double.parse(lon1)),
        new LatLng(double.parse(lat2), double.parse(lon2)));
    return dis;
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Payment card updated successfully'),
      ));
    });
  }
}

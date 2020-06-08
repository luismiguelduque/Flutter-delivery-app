import 'package:intl/intl.dart';

import '../models/address.dart';
import '../models/food_order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';

class Order {
  String id;
  List<FoodOrder> foodOrders;
  OrderStatus orderStatus;
  double tax;
  double deliveryFee;
  int deliveryFeeType;
  String hint;
  DateTime dateTime;
  DateTime orderTime;
  User user;
  Payment payment;
  Address deliveryAddress;
  int driverId;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    // print(jsonMap);
    try {
      id = jsonMap['id'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      deliveryFeeType = jsonMap['delivery_fee_type'] != null
          ? jsonMap['delivery_fee_type'].toInt()
          : 0;
      driverId =
          jsonMap['driver_id'] != null ? jsonMap['driver_id'].toInt() : -1;
      hint = jsonMap['hint'].toString();
      orderStatus = jsonMap['order_status'] != null
          ? OrderStatus.fromJSON(jsonMap['order_status'])
          : new OrderStatus();
      dateTime = DateTime.parse(jsonMap['updated_at']);
      orderTime = jsonMap['order_time'] != null
          ? DateTime.parse(jsonMap['order_time'])
          : null;
      user =
          jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
      deliveryAddress = jsonMap['delivery_address'] != null
          ? Address.fromJSON(jsonMap['delivery_address'])
          : new Address();
      foodOrders = jsonMap['food_orders'] != null
          ? List.from(jsonMap['food_orders'])
              .map((element) => FoodOrder.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map["delivery_fee_type"] = foodOrders[0].food.restaurant.deliveryFeeType;
    map["delivery_fee"] = deliveryFee;
    map["foods"] = foodOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment.toMap();
    map["order_time"] = DateFormat('yyyy-MM-dd HH:mm').format(orderTime);
    map["delivery_address_id"] = deliveryAddress?.id ?? null;
    return map;
  }

  Map deliveredMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["order_status_id"] = 5;
    return map;
  }
}

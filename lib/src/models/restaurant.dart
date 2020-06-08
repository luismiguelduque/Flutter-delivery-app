import '../models/media.dart';

class Restaurant {
  String id;
  String name;
  Media image;
  String rate;
  String address;
  String description;
  String phone;
  String mobile;
  String information;
  int deliveryFeeType;
  double deliveryFee;
  double adminCommission;
  String latitude;
  String longitude;
  double distance;
  Map<String, String> workingTime = new Map<String, String>();

  Restaurant();

  Restaurant.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    image = jsonMap['media'] != null ? Media.fromJSON(jsonMap['media'][0]) : null;
    rate = jsonMap['rate'] ?? '0';
    deliveryFeeType = jsonMap['delivery_fee_type'] != null ? jsonMap['delivery_fee_type'].toInt() : 0;
    deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
    adminCommission = jsonMap['admin_commission'] != null ? jsonMap['admin_commission'].toDouble() : 0.0;
    address = jsonMap['address'];
    description = jsonMap['description'];
    phone = jsonMap['phone'];
    mobile = jsonMap['mobile'];
    information = jsonMap['information'];
    latitude = jsonMap['latitude'];
    longitude = jsonMap['longitude'];
    distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;
    workingTime['monday_from'] = jsonMap['monday_from'];
    workingTime['monday_to'] = jsonMap['monday_to'];
    workingTime['tuesday_from'] = jsonMap['tuesday_from'];
    workingTime['tuesday_to'] = jsonMap['tuesday_to'];
    workingTime['wednesday_from'] = jsonMap['wednesday_from'];
    workingTime['wednesday_to'] = jsonMap['wednesday_to'];
    workingTime['thursday_from'] = jsonMap['thursday_from'];
    workingTime['thursday_to'] = jsonMap['thursday_to'];
    workingTime['friday_from'] = jsonMap['friday_from'];
    workingTime['friday_to'] = jsonMap['friday_to'];
    workingTime['saturday_from'] = jsonMap['saturday_from'];
    workingTime['saturday_to'] = jsonMap['saturday_to'];
    workingTime['sunday_from'] = jsonMap['sunday_from'];
    workingTime['sunday_to'] = jsonMap['sunday_to'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }
}

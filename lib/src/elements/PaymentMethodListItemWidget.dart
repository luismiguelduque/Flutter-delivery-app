import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';

import '../models/payment_method.dart';

// ignore: must_be_immutable
class PaymentMethodListItemWidget extends StatelessWidget {
  String heroTag;
  PaymentMethod paymentMethod;

  PaymentMethodListItemWidget({Key key, this.paymentMethod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        if (paymentMethod.route == '/CashOnDelivery' ||
            paymentMethod.route == '/PayOnPickup' ||
            paymentMethod.route == '/PayPal' ||
            paymentMethod.route == '/Mercado')
          DatePicker.showDateTimePicker(
            context,
            // showTitleActions: true,
            minTime: DateTime.now(),
            maxTime: DateTime(2025, 12, 31, 11, 59, 59),
            onCancel: () {
              if (paymentMethod.route == '/PayPal')
                Navigator.of(context).pushNamed('/PayPal',
                    arguments: new RouteArgument(orderTime: null));
              else if (paymentMethod.route == '/Mercado')
                Navigator.of(context).pushNamed('/Mercado',
                    arguments: new RouteArgument(orderTime: null));
              else
                Navigator.of(context).pushNamed('/OrderSuccess',
                    arguments: new RouteArgument(
                        param: paymentMethod.name, orderTime: null));
            },
            onConfirm: (date) {
              if (paymentMethod.route == '/PayPal')
                Navigator.of(context).pushNamed('/PayPal',
                    arguments: new RouteArgument(orderTime: date));
              else if (paymentMethod.route == '/Mercado')
                Navigator.of(context).pushNamed('/Mercado',
                    arguments: new RouteArgument(orderTime: date));
              else
                Navigator.of(context).pushNamed('/OrderSuccess',
                    arguments: new RouteArgument(
                        param: paymentMethod.name, orderTime: date));
            },
            currentTime: DateTime.now(),
          );
        else
          Navigator.of(context).pushNamed(this.paymentMethod.route);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                    image: AssetImage(paymentMethod.logo), fit: BoxFit.fill),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          paymentMethod.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          paymentMethod.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).focusColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

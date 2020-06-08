import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/i18n.dart';
import 'package:food_delivery_app/src/elements/ExtraItemWidget.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class CartWidget extends StatefulWidget {
  RouteArgument routeArgument;
  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;
  bool flag = false;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (widget.routeArgument.param == '/Food') {
                Navigator.of(context).pushReplacementNamed('/Food',
                    arguments: RouteArgument(id: widget.routeArgument.id));
              } else {
                Navigator.of(context)
                    .pushReplacementNamed('/Pages', arguments: 2);
              }
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).cart,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 150),
                      padding: EdgeInsets.only(bottom: 15),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.shopping_cart,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).shopping_cart,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                subtitle: Text(
                                  S
                                      .of(context)
                                      .verify_your_quantity_and_click_checkout,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ),
                            ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.carts.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 15);
                              },
                              itemBuilder: (context, index) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CartItemWidget(
                                        cart: _con.carts.elementAt(index),
                                        heroTag: 'cart',
                                        increment: () {
                                          flag = false;
                                          _con.incrementQuantity(
                                              _con.carts.elementAt(index));
                                        },
                                        decrement: () {
                                          flag = false;
                                          _con.decrementQuantity(
                                              _con.carts.elementAt(index));
                                        },
                                        onDismissed: () {
                                          flag = true;
                                          _con.removeFromCart(
                                              _con.carts.elementAt(index));
                                        },
                                      ),
                                      ListView.separated(
                                        padding: EdgeInsets.all(0),
                                        itemBuilder: (context, id) {
                                          return ExtraItemWidget(
                                            flag: flag,
                                            extra: _con.carts
                                                .elementAt(index)
                                                .food
                                                .extras
                                                .elementAt(id),
                                            onChanged: () {
                                              flag = false;
                                              _con.refreshExtras(index, id);
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, id) {
                                          return SizedBox(height: 20);
                                        },
                                        itemCount: _con.carts
                                            .elementAt(index)
                                            .food
                                            .extras
                                            .length,
                                        primary: false,
                                        shrinkWrap: true,
                                      ),
                                    ]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 130,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, -2),
                                  blurRadius: 5.0)
                            ]),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).subtotal,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Helper.getPrice(_con.subTotal, context,
                                      style:
                                          Theme.of(context).textTheme.subtitle1)
                                ],
                              ),
                              SizedBox(height: 10),
                              Stack(
                                fit: StackFit.loose,
                                alignment: AlignmentDirectional.centerEnd,
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: FlatButton(
                                      onPressed: () {
                                        DateTime now = DateTime.now();
                                        String weekday =
                                            _con.weekdays[now.weekday - 1];
                                        String curTime =
                                            DateFormat('HH:mm').format(now);
                                        String hoursFrom = _con
                                            .carts[0]
                                            .food
                                            .restaurant
                                            .workingTime[weekday + '_from'];
                                        String hoursTo = _con
                                            .carts[0]
                                            .food
                                            .restaurant
                                            .workingTime[weekday + '_to'];
                                        DateTime curDateTime =
                                            DateFormat('HH:mm').parse(curTime);
                                        DateTime from = DateFormat('HH:mm')
                                            .parse(hoursFrom);
                                        DateTime to =
                                            DateFormat('HH:mm').parse(hoursTo);
                                        if (curDateTime.isAfter(from) &&
                                            curDateTime.isBefore(to))
                                          Navigator.of(context).pushNamed(
                                              '/DeliveryAddresses',
                                              arguments: new RouteArgument(
                                                  param: [
                                                    _con.carts,
                                                    _con.total,
                                                    setting.value.defaultTax
                                                  ]));
                                        else
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return SimpleDialog(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20),
                                                  titlePadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 15,
                                                          vertical: 20),
                                                  title: Row(
                                                    children: <Widget>[
                                                      Icon(Icons.warning),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        S.of(context).overtime,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      )
                                                    ],
                                                  ),
                                                  children: <Widget>[
                                                    Form(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                            S
                                                                .of(context)
                                                                .overtime_msg,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            S.of(context).from +
                                                                hoursFrom +
                                                                S
                                                                    .of(context)
                                                                    .to +
                                                                hoursTo,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      children: <Widget>[
                                                        MaterialButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                    ),
                                                    SizedBox(height: 10),
                                                  ],
                                                );
                                              });
                                      },
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      color: Theme.of(context).accentColor,
                                      shape: StadiumBorder(),
                                      child: Text(
                                        S.of(context).checkout,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

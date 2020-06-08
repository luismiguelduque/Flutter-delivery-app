import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../repository/cart_repository.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;
  var weekdays = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        _cart.extras.forEach((extra) {
          for (int i = 0; i < _cart.food.extras.length; i++) {
            if (extra.id == _cart.food.extras.elementAt(i).id) {
              _cart.food.extras.elementAt(i).checked = true;
            }
          }
        });
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateSubtotal();
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    listenForCarts(message: S.current.carts_refreshed_successfully);
  }

  void removeFromCart(Cart _cart) async {
    carts.remove(_cart);
    for(int i=0;i<carts.length;i++) {
      if (carts.elementAt(i) == _cart)
        carts.removeAt(i);
    }
    calculateSubtotal();
    removeCart(_cart).then((value) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            S.current.the_food_was_removed_from_your_cart(_cart.food.name)),
      ));
    });
  }
  void refreshExtras(int index, int i) {
    carts.elementAt(index).extras = new List();
    carts.elementAt(index).food.extras.forEach((extra) {
      if (extra.checked)
        carts.elementAt(index).extras.add(extra);
    });
    updateCart(carts.elementAt(index));
    calculateSubtotal();
  }

  void calculateSubtotal() async {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal += cart.quantity * cart.getFoodPrice();
    });
    setState(() {});
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  Future<bool> listenForLoadLastOrderCarts() async {
    return loadedLastOrderCarts();
  }
}

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/helper.dart';

import '../models/food.dart';
import '../models/route_argument.dart';

class FoodGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Food food;
  final VoidCallback onPressed;

  FoodGridItemWidget({Key key, this.heroTag, this.food, this.onPressed}) : super(key: key);

  @override
  _FoodGridItemWidgetState createState() => _FoodGridItemWidgetState();
}

class _FoodGridItemWidgetState extends State<FoodGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Food', arguments: new RouteArgument(heroTag: this.widget.heroTag, id: this.widget.food.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: widget.heroTag + widget.food.id,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(this.widget.food.image.thumb), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.food.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                widget.food.restaurant.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                print('onpressed');
                widget.onPressed();
              },
              child: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).accentColor.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(end: 10, top: 100, start: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            height: 28,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).accentColor),
            alignment: AlignmentDirectional.topEnd,
            child: Helper.getWaitingTime(
              widget.food.waitingTime,
              context,
              style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}

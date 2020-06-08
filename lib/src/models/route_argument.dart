class RouteArgument {
  String id;
  String heroTag;
  dynamic param;
  DateTime orderTime;

  RouteArgument({this.id, this.heroTag, this.param, this.orderTime});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}

class RouteNotFoundException implements Exception {
  final String routeName;

  RouteNotFoundException(this.routeName);

  @override
  String toString() => 'Route "$routeName" not found';
}

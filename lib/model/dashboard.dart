class MapModel {
  String? lastUpdated;
  InitialRoute? initialLocation;
  List<Markers>? markers;
  List<Routes>? routes;
}

class Markers {
  String? label;
  String? color;
  double? latitude;
  double? longitude;
}

class Routes {
  String? from;
  String? to;
  String? type;
  int? totalTransaction;
  String? colorFrom;
  String? colorTo;
  String? roadColor;
}

class InitialRoute {
  double? latitude;
  double? longitude;
}

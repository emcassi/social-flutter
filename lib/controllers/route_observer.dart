import 'package:flutter/material.dart';

class RouteObserverProvider {
  static final RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();

  static RouteObserver<PageRoute> of(BuildContext context) {
    // Retrieve the RouteObserver from the context
    return _routeObserver;
  }
}
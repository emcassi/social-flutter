import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:social/controllers/route_observer.dart';

mixin PageAware<T extends StatefulWidget> on State<T> implements RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register this widget as a route observer when it is created or dependencies change
    final route = ModalRoute.of(context) as PageRoute<dynamic>?; // Explicit cast
    if (route != null) {
      RouteObserverProvider.of(context).subscribe(this, route);
    }
  }

  @override
  void dispose() {
    // Unregister this widget when it is disposed
    RouteObserverProvider.of(context).unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Called when the route containing this widget is pushed onto the navigator
    // Widget is appearing on the screen
    onPageVisible();
  }

  @override
  void didPopNext() {
    // Called when the route containing this widget is popped from the navigator
    // Widget is reappearing on the screen after being previously hidden
    onPageVisible();
  }

  void onPageVisible() {
  }
}

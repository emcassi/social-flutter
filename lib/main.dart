import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/components/app.dart';
import 'package:social/controllers/route_observer.dart';
import 'package:social/firebase_options.dart';
import 'package:social/providers/user_provider.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userProvider = UserProvider();
    userProvider.fetchUser();
  }

  @override
  Widget build(BuildContext context) {

    final RouteObserver<Route<dynamic>> routeObserver = RouteObserverProvider.of(context);

    return ChangeNotifierProvider<UserProvider>(create: (_) => userProvider,
      child: MaterialApp(
          navigatorObservers: [routeObserver],
        title: 'My App',
        theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
        home: AppView(),
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_health_app/home.dart';
import 'package:provider/provider.dart';
import 'providers.dart';
import 'routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.providers,
      child: MaterialApp(
        title: 'Mobile Health Application',
        home: const HomeScreen(),
        routes: Routes.routes,
      ),
    );
  }
}
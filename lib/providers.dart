import 'package:flutter_health_app/src/providers/tab_manager.dart';
import 'package:provider/provider.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider(create: (context) => TabManager()),
  ].toList();
}

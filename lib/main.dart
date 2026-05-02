import 'package:atelier/config/atelier_app.dart';
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Edge-to-edge: the app paints under the status bar and the system
  // navigation bar so the scaffold background bleeds all the way to the
  // physical edges. AnnotatedRegion in AtelierApp tints the bar overlays
  // to match the active theme.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final database = AtelierDatabase();
  final prefs = await SharedPreferences.getInstance();
  runApp(AtelierApp(database: database, prefs: prefs));
}

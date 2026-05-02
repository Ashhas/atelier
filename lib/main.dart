import 'package:atelier/config/atelier_app.dart';
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AtelierDatabase();
  final prefs = await SharedPreferences.getInstance();
  runApp(AtelierApp(database: database, prefs: prefs));
}

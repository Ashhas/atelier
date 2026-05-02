import 'package:atelier/domain/models/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> read();
  Future<void> write(AppSettings settings);
  Future<void> clear();
}

import 'package:atelier/domain/models/app_settings.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({this.settings = const AppSettings(), this.loaded = false});

  final AppSettings settings;
  final bool loaded;

  SettingsState copyWith({AppSettings? settings, bool? loaded}) => SettingsState(
    settings: settings ?? this.settings,
    loaded: loaded ?? this.loaded,
  );

  @override
  List<Object?> get props => [settings, loaded];
}

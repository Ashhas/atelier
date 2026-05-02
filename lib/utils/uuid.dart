import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Returns a fresh UUID v4 string. Centralised so tests can swap it via DI later.
String newId() => _uuid.v4();

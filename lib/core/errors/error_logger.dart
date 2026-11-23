import 'package:flutter/foundation.dart';

/// Every uncaught error ends up here (see main.dart).
/// Today: prints to the console. Production: send to Crashlytics or Sentry.
class ErrorLogger {
  static void log(Object error, StackTrace? stack) {
    debugPrint('APP ERROR: $error');
    if (stack != null) debugPrint('$stack');
    // TODO(production): FirebaseCrashlytics.instance.recordError(error, stack);
  }
}

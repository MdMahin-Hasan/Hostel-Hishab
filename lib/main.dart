import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hisab/app/app.dart';
import 'package:hostel_hisab/core/errors/error_logger.dart';
import 'package:hostel_hisab/core/widgets/friendly_error.dart';

void main() {
  // The "safety zone": async errors nobody caught land in the handler below.
  runZonedGuarded<Future<void>>(
    () async {
      // IMPORTANT: ensureInitialized and runApp must be inside THIS zone,
      // otherwise Flutter prints a "zone mismatch" warning.
      WidgetsFlutterBinding.ensureInitialized();

      // Errors thrown by Flutter itself (build, layout, painting).
      FlutterError.onError = (details) {
        FlutterError.presentError(details); // keep the console output in debug
        ErrorLogger.log(details.exception, details.stack);
      };

      // Release builds: friendly message instead of the grey error box.
      final defaultBuilder = ErrorWidget.builder;
      ErrorWidget.builder =
          (details) => kReleaseMode ? const FriendlyError() : defaultBuilder(details);

      runApp(const HostelHisabApp());
    },
    (error, stack) => ErrorLogger.log(error, stack),
  );
}

import 'package:flutter/material.dart';
import 'package:hostel_hisab/app/app_providers.dart';
import 'package:hostel_hisab/app/routes.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

class HostelHisabApp extends StatelessWidget {
  const HostelHisabApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider sits ABOVE MaterialApp so every screen can reach providers.
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        title: 'হোস্টেল হিসাব',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            // Big system fonts are allowed up to 1.3x, so layouts do not break.
            data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: 1.3)),
            // Tablets / web / landscape: keep the phone layout centred, max 600px wide.
            child: ColoredBox(
              color: AppColors.background,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: child,
                ),
              ),
            ),
          );
        },
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}

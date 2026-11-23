import 'package:flutter/material.dart';
import 'package:hostel_hisab/features/auth/presentation/screens/login_screen.dart';
import 'package:hostel_hisab/features/finance/presentation/screens/deposit_screen.dart';
import 'package:hostel_hisab/features/members/presentation/screens/members_screen.dart';
import 'package:hostel_hisab/features/shell/presentation/screens/main_shell.dart';

class AppRoutes {
  static const login = '/login';
  static const shell = '/';
  static const deposit = '/deposit';
  static const members = '/members';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      shell => const MainShell(),
      deposit => const DepositScreen(),
      members => const MembersScreen(),
      _ => const LoginScreen(),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}

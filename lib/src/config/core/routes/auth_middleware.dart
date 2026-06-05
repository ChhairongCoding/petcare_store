import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      // User is not logged in, redirect to login screen
      return RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}

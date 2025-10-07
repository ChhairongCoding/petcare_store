import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/services/local_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final LocalService token = LocalService();
  final _supabaseClient = Supabase.instance.client;

  Future<void> login(String email, String password) async {
    try {
      if (password.isEmpty || email.isEmpty) return;
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        await token.saveToken(response.session!.accessToken);
        print('Login successful: ${response.session!.accessToken}');
        Get.offNamed(AppRoutes.mainScreen);
        SnackBar(content: Text('Login successful'));
      } else {
        print('Login failed: No session returned');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  String? get currentToken {
    final session = _supabaseClient.auth.currentSession;
    return session?.accessToken;
  }
}

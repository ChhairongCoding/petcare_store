import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/services/local_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

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
        developer.log('Login successful: ${response.session!.accessToken}');
        Get.offNamed(AppRoutes.mainScreen);
        SnackBar(content: Text('Login successful'));
      } else {
        developer.log('Login failed: No session returned');
      }
    } catch (e) {
      developer.log('Error logging in: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
      await token.removeToken();
      await LocalService().removeToken();
      Get.offNamed(AppRoutes.login);
    } catch (e) {
      developer.log('Error logging out: $e');
    }
  }
  String? get currentToken {
    final session = _supabaseClient.auth.currentSession;
    return session?.accessToken;
  }
}

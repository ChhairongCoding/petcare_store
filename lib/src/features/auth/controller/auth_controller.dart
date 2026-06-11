import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/services/local_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

class AuthController extends GetxController {
  final LocalService token = LocalService();
  RxBool isLoading = false.obs;
  final _supabaseClient = Supabase.instance.client;

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    isLoading.value = true;
    try {
      if (password.isEmpty || email.isEmpty) return false;
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        await token.saveToken(response.session!.accessToken);
        developer.log('Login successful: ${response.session!.accessToken}');
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } on AuthException catch (e) {
      if (!context.mounted) return false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login failed'),
            content: Text(e.message),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
      isLoading.value = false;
      developer.log('Error logging in: ${e.message}');
      return false;
    } catch (e) {
      isLoading.value = false;
      developer.log('Error logging in: $e');
      return false;
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

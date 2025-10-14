import 'package:get/get.dart';
import 'package:petcare_store/features/profile/models/profile_model.dart';
import 'package:petcare_store/services/auth_service.dart';
import 'package:petcare_store/services/local_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final LocalService _localService = Get.find<LocalService>();
  final _supabaseClient = Supabase.instance.client;

  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (!_authService.isLoggedIn) return;

    try {
      isLoading.value = true;
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return;

      // Fetch profile from profiles table (assuming it exists)
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      profile.value = ProfileModel.fromJson(response);
    } catch (e) {
     
      final user = _supabaseClient.auth.currentUser;
      if (user != null) {
        profile.value = ProfileModel(
          id: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'],
          createdAt: user.createdAt.isNotEmpty ? DateTime.parse(user.createdAt) : null,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(ProfileModel updatedProfile) async {
    try {
      isLoading.value = true;

      final response = await _supabaseClient
          .from('profiles')
          .upsert(updatedProfile.toJson())
          .select()
          .single();

      profile.value = ProfileModel.fromJson(response);
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      developer.log('Error updating profile: $e');
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
      await _localService.removeToken();
      Get.offAllNamed('/login');
    } catch (e) {
      developer.log('Error logging out: $e');
    }
  }
}

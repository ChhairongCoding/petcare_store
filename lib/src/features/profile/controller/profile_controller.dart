import 'package:get/get.dart';
import 'package:petcare_store/src/features/profile/models/profile_model.dart';
// import 'package:petcare_store/services/auth_service.dart';
import 'package:petcare_store/src/services/local_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

class ProfileController extends GetxController {
  // final AuthService _authService = Get.find<AuthService>();
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

    try {
      isLoading.value = true;
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return;

      // Try to fetch from 'profiles' table
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        // Found profile in DB
        profile.value = ProfileModel.fromJson(response);
      } else {
        // No record in 'profiles', fallback to auth.user
        profile.value = ProfileModel(
          id: user.id,
          email: user.email ?? '',
          name:
          response?['full_name'],
          avatar: response?['avatar'],
          createdAt: user.createdAt,
        );
      }

      // print('Loaded profile: ${response?['full_name']}');
    } catch (e, stack) {
      print('Error loading profile: $e\n$stack');
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
